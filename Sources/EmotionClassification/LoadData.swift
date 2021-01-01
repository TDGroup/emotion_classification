//
//  File.swift
//  
//
//  Created by Thu on 12/30/20.
//

import Foundation
import Accelerate

var sampling_rate = 512
let number_of_channel = 1
let number_of_audio = 20
var number_of_second_per_audio = 30
let realtime_eeg_in_second = number_of_audio * number_of_second_per_audio
let number_of_realtime_eeg = sampling_rate * realtime_eeg_in_second

let number_of_frequency = 5
let number_of_feature = 2
let number_of_training_column = number_of_frequency * number_of_feature

let number_of_sample_per_audio = sampling_rate * number_of_second_per_audio
let path = "/"

public class Emotion
{
    public var number_of_second = 30
    public var sample_rate = 512
    /*
    Get data from csv and convert them to number array.
    Input: Path csv file.
    Output: Number array from csv data.
 */
    public init(number_of_second: Int, sample_rate: Int){
        self.number_of_second = number_of_second
        self.sample_rate = sample_rate
        number_of_second_per_audio = self.number_of_second
        sampling_rate = self.sample_rate
    }

    public func get_csv(path: String) -> [[Double]]
    {
        var result : [[Double]] = [[]]
        //Read file
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL : URL = dir.appendingPathComponent(path)
            do {
                let s = try String(contentsOf: fileURL)
                let lines = s.split(separator: "\n")
                for i in 0..<lines.count {
                    let line = lines[i]
                    let columns = line.split(separator: ",", omittingEmptySubsequences: false)
                    var row : [Double] = []
                    for j in 0..<columns.count {
                        if let item = Double(columns[j]) {
                            row.append(item)
                        }else{
                            row.append(0.0)
                        }
                    }
                    result.append(row)
                }
            }
            catch{
                
            }
        }
        result.remove(at:0)
        return result
    }
    
    public func do_fft(_ input: [Double], _ index: Int) -> [Double]{
        let c = convertDoubleArr(input)
        let fftValues = fft(c, index)
//        print(fftValues)
        return convertArr(fftValues)
    }
    
    public func get_frequency(_ input: [Double], _ index: Int) -> (delta: [Double], theta: [Double], alpha: [Double], beta: [Double], gamma: [Double]){
//      Length data channel
        let L = input.count

//      Sampling frequency
        let Fs = sampling_rate

//      Get fft data
        let data_fft = do_fft(input, index)
//        print(data_fft)

//      Compute frequency
        
        var frequency : [Double] = []
        for item in data_fft{
            let tmp = fabs(item / Double(L))
            frequency.append(tmp)
        }
//        print(frequency)
        let end = Int(L / 2 + 1)
        var new_frequency : [Double] = []
        for i in 0..<end {
            let tmp = fabs(frequency[i] * Double(2))
            new_frequency.append(tmp)
        }
//        print(new_frequency)

//        # Filter only frequency from 1 - 50 Hz
        let start_delta = Int(L * 1 / Fs - 1)
        let start_theta = Int(L * 4 / Fs - 1)
        let start_alpha = Int(L * 8 / Fs - 1)
        let start_beta = Int(L * 13 / Fs - 1)
        let start_gamma = Int(L * 30 / Fs - 1)
        let end_delta = Int(L * 4 / Fs)
        let end_theta = Int(L * 8 / Fs)
        let end_alpha = Int(L * 13 / Fs)
        let end_beta = Int(L * 30 / Fs)
        let end_gamma = Int(L * 50 / Fs)
        
        let delta = Array(frequency[start_delta..<end_delta])
        let theta = Array(frequency[start_theta..<end_theta])
        let alpha = Array(frequency[start_alpha..<end_alpha])
        let beta = Array(frequency[start_beta..<end_beta])
        let gamma = Array(frequency[start_gamma..<end_gamma])

//        print(delta, theta, alpha, beta, gamma)

        return (delta, theta, alpha, beta, gamma)
    }
    
    public func get_feature(_ input: [Double], _ index: Int)->[Double]{
//        # Get frequency data
        let bands = get_frequency(input, index)
        let delta = bands.delta
        let theta = bands.theta
        let alpha = bands.alpha
        let beta = bands.beta
        let gamma = bands.gamma

//        # Compute feature std
        let delta_std = delta.std()
        let theta_std = theta.std()
        let alpha_std = alpha.std()
        let beta_std = beta.std()
        let gamma_std = gamma.std()

//        # Compute feature mean
        let delta_m = delta.mean()
        let theta_m = theta.mean()
        let alpha_m = alpha.mean()
        let beta_m = beta.mean()
        let gamma_m = gamma.mean()

//        # Concate feature
        let feature = [delta_std, delta_m, theta_std, theta_m, alpha_std, alpha_m, beta_std, beta_m, gamma_std, gamma_m]
        
//        feature = feature.T
//        feature = feature.ravel()

        return feature
    }
    
    public func filter_raw_data(input_url: String, output_url: String){
        var result : [[Double]] = [[]]
        //Read file
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL : URL = dir.appendingPathComponent(input_url)
            do {
                let s = try String(contentsOf: fileURL)
                let lines = s.split(separator: "\n")
                for i in 0..<lines.count {
                    let line = lines[i]
                    let columns = line.split(separator: ",", omittingEmptySubsequences: false)
                    var row : [Double] = []
                    if let item = Double(columns[0]){
                        row.append(item)
                    }else{
                        row.append(0.0)
                    }
                    result.append(row)
                }
                // Save to output file
                result.remove(at: 0)
                createCSV(from: result, output: output_url)
            }
            catch{
                
            }
//        }
        }
    }
    
    public func create_emotion_file(input_datas: [String], input_classes: [String]){
        print(input_datas.count)
        let count = input_datas.count * number_of_audio
        var train_data : [[Double]] = [[]]
//        train_data = np.zeros((count, number_of_training_column), dtype=np.double)
        for n in 0..<input_datas.count{
            let inputfile = input_datas[n]
            var raw_data : [[Double]] = get_csv(path: inputfile)
            
            for i in 0..<number_of_audio{
                var train_1_image : [Double] = []
//                    np.zeros((number_of_channel, number_of_sample_per_audio), dtype=np.double)

                for j in 0..<number_of_sample_per_audio{
                    let next = i * number_of_sample_per_audio + j
                    if next >= raw_data.count{
                        break
                    }
                    train_1_image.append(contentsOf: raw_data[next])
                }
                if train_1_image.count > 0{
                    let feature = get_feature(train_1_image, i)
//                train_data[n * number_of_audio + i] = feature
                    train_data.append(feature)
                }
            }
        }
        train_data.remove(at: 0)
        
        let output1 = path + "features.csv"
        createCSV(from: train_data, output: output1)

//        var class_data : [[Float]] = [[]]
//        var column : [Float] = []
//        for i in 0..<input_classes.count{
//            let inputClassfile = input_classes[i]
//
//            let classes = get_csv(path: inputClassfile)
//
//            for j in 0..<number_of_audio{
//                column.append(classes[j][1])
////                class_data[0][i * number_of_audio + j] = classes[j][1]
//            }
//        }
//        class_data.append(column)
//        class_data.remove(at:0)
//        let output2 = path + "classes.csv"
//        createCSV(from: class_data, output: output2)

        print(train_data)
    }
    
    func convertArr(_ input: [Float]) -> [Double]{
        var result : [Double] = []
        for i in 0..<input.count{
            result.append(Double(input[i]))
//            result[i] = Double(input[i])
        }
        return result
    }
    
    func convertDoubleArr(_ input: [Double]) -> [Float]{
            var result : [Float] = []
            for i in 0..<input.count{
                result.append(Float(input[i]))
    //            result[i] = Double(input[i])
            }
            return result
        }
    
    public func classify(input_data: [Double],train_file: String, class_file: String) -> Int{
        let features : [[Double]] = get_csv(path: train_file)
        let classes : [[Double]] = get_csv(path: class_file)
//        let features = convert(train_features)
//        let classes = convert(train_classes)
        let data = DataSet(dataType: .Classification, inputDimension: 10, outputDimension: 1)
        do {
            for i in 0..<features.count{
                try data.addDataPoint(input: features[i], output:Int(classes[0][i]))
                
            }
//            try data.addDataPoint(input: [0.0, 1.0], output:1)
        }
        catch {
            print("Invalid data set created")
        }
                
        //  Create an SVM classifier and train
//        let svm = SVMModel(problemType: .C_SVM_Classification, kernelSettings:
//                            KernelParameters(type: .RadialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
        let svm = SVMModel(problemType: .C_SVM_Classification, kernelSettings:
            KernelParameters(type:.Linear, degree: 0, gamma: 0.0, coef0: 0.0))
        
        svm.train(data: data)
                
        //  Create a test dataset
        let testData = DataSet(dataType: .Classification, inputDimension: 10, outputDimension: 1)
        do {
            try testData.addTestDataPoint(input: input_data)
//            try testData.addTestDataPoint(input: [0.5, 0.6])    //  Expect 1
        }
        catch {
            print("Invalid data set created")
        }
                
        //  Predict on the test data
        svm.predictValues(data: testData)
                
        //  See if we matched
        var classLabel : Int
        do {
            try classLabel = testData.getClass(index: 0)
            print("Predict:", classLabel)
            return classLabel
        }
        catch {
            print("Error in prediction")
            return -1
        }
    }
}

public func emotion(_ input:[[Double]]) -> [Int]{
    var predict : [Int] = []
    let e = Emotion(number_of_second: 1, sample_rate: 100)
    
//    e.filter_raw_data(input_url: "chi_happy.csv", output_url: "train-chi-happy.csv")
//    e.filter_raw_data(input_url: "chi_sad.csv", output_url: "train-chi-sad.csv")
//    e.filter_raw_data(input_url: "truong_happy.csv", output_url: "train-truong-happy.csv")
//    e.filter_raw_data(input_url: "truong_sad.csv", output_url: "train-truong-sad.csv")
//    e.create_emotion_file(input_datas: ["train-chinedu-happy.csv","train-chinedu-sad.csv"], input_classes: ["classes.csv"])
//    e.create_emotion_file(input_datas: ["train-truong-happy.csv","train-truong-sad.csv"], input_classes: ["classes.csv"])
    for item in input{
        let cl = e.classify(input_data: item, train_file: "features.csv", class_file: "classes.csv")
        predict.append(cl)
    }
//    predict.remove(at: 0)
    return predict
}
