//
//  FFT.swift
//  UIImage+Spectrogram
//
//  Created by AL on 22/08/2018.
//  Copyright © 2018 Alban. All rights reserved.
//

import Foundation
import Accelerate

struct Rescale<Type : BinaryFloatingPoint> {
    typealias RescaleDomain = (lowerBound: Type, upperBound: Type)
    
    var fromDomain: RescaleDomain
    var toDomain: RescaleDomain
    
    init(from: RescaleDomain, to: RescaleDomain) {
        self.fromDomain = from
        self.toDomain = to
    }
    
    func interpolate(_ x: Type ) -> Type {
        return self.toDomain.lowerBound * (1 - x) + self.toDomain.upperBound * x;
    }
    
    func uninterpolate(_ x: Type) -> Type {
        let b = (self.fromDomain.upperBound - self.fromDomain.lowerBound) != 0 ? self.fromDomain.upperBound - self.fromDomain.lowerBound : 1 / self.fromDomain.upperBound;
        return (x - self.fromDomain.lowerBound) / b
    }
    
    func rescale(_ x: Type )  -> Type {
        return interpolate( uninterpolate(x) )
    }
}

public func fft(_ input: [Float], _ index: Int) -> [Float] {
    print("Calculate FFT for item ", index)
    print("With data: ", input)
    var real = input
    let size = real.count
    
    var imaginary = [Float](repeating: 0.0, count: input.count)
    var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(size))))
    let radix = FFTRadix(kFFTRadix5)
    let weights = vDSP_create_fftsetup(length, radix)
    
    vDSP_fft_zip(weights!, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
    vDSP_destroy_fftsetup(weights)
    
    return imaginary
}

func applyWindow(_ signal:[Float]) -> [Float] {
//    // Hamming
    let size = signal.count
    var windowedSignal = [Float](repeating: 0.0, count: size)
    var window = [Float](repeating: 0.0, count: size)
    vDSP_hamm_window(&window, UInt(size), 0)
    vDSP_vmul(signal, 1, window, 1, &windowedSignal, 1, UInt(size))
    return windowedSignal
}

func substracValue(_ values:Float, toSignal signal:[Float]) -> [Float] {
    
    let size = signal.count
    var sub:[Float] = [Float](repeating: -values, count: size)
    var substractedValues = [Float](repeating: 0.0, count: Int(size))
    vDSP_vsub(signal, 1, &sub, 1, &substractedValues, 1, vDSP_Length(size))
    return substractedValues
}


public func meanOfSignal(_ values:[Float]) -> Float {
    var mean:Float = 0
    vDSP_meanv(values, 1, &mean, vDSP_Length(values.count))
    return mean
}

//public func std(_ values:[Float]) -> Float {
//    let mean = meanOfSignal(values)
//    let v = values.reduce(0, { $0 + ($1-mean)*($1-mean) })
//    return sqrt(v / (Float(values.count)))
//}

public func normalizeFFT(_ values:[Float]) -> [Float] {
    
    let size = values.count
    var normalizedValues = [Float](repeating: 0.0, count: Int(size))
    var origninalSize = Float(values.count*2)
    vDSP_vsmul(values, 1, &origninalSize, &normalizedValues, 1, vDSP_Length(Int(size)))
    
    return normalizedValues
}

func normalize(_ values:[Float]) -> [Float] {
    if let min = values.min(),
        let max = values.max() {
        
        return values.map{ Rescale(from: (min,max), to: (0,1)).rescale($0) }
        
    }else{
        return values
    }
    
}

public func squareValues(_ values:[Float]) -> [Float] {
    let size = values.count
    var squaredValues = [Float](repeating: 0.0, count: size)
    vDSP_vsq(values, 1, &squaredValues, 1, vDSP_Length(size))
    return squaredValues
}

public func ifft(_ real: [Float],img: [Float]) -> [Float] {
    
    var real = real
    var size:Float = Float(real.count)
    var normalizeSize = 1.0/size

    var imaginary = img

    vDSP_vsmul(real, 1, &normalizeSize, &real, 1, vDSP_Length(size))
    vDSP_vsmul(imaginary, 1, &normalizeSize, &imaginary, 1, vDSP_Length(size))
    
    var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(size))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetup(length, radix)
    vDSP_fft_zip(weights!, &splitComplex, 1, length, FFTDirection(FFT_INVERSE))
    
    vDSP_destroy_fftsetup(weights)
    
    return real
}
