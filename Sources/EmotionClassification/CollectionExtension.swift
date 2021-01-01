//
//  File.swift
//  
//
//  Created by Thu on 12/30/20.
//

import Foundation
import Accelerate

public extension Array where Element: FloatingPoint {

    func sum() -> Element {
        return self.reduce(0, +)
    }

    func mean() -> Element {
        return self.sum() / Element(self.count)
    }

    func std() -> Element {
        let mean = self.mean()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Element(self.count)))
        
//        let length = Element(self.count)
//        let avg = self.reduce(0, {$0 + $1}) / length
//        let sumOfSquaredAvgDiff = self.map { pow(Double($0 - avg), 2.0)}.reduce(0, {$0 + $1})
//        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    func substract(substractor: [Element]) -> [Element]{
        if substractor.count < self.count{
            return []
        }
        var result = [Element]()
        for index in 0..<self.count {
            let tmp = self[index] - substractor[index]
            result.append(tmp)
        }
        return result
    }

}
