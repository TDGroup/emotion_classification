//
//  File.swift
//  
//
//  Created by Thu on 12/30/20.
//

import Foundation

public func createCSV(from recArray:[[Double]], output: String){
//        var csvString = "\(""),\("")\n\n"
    var csvString = ""
    for i in 0..<recArray.count {
        let row = recArray[i]
        for j in 0..<row.count{
            let str = String(describing: row[j])
            if j == row.count - 1{
                csvString = csvString.appending("\(str)")
            }else{
                csvString = csvString.appending("\(str),")
            }
        }
        csvString = csvString.appending("\n")
    }

        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(path)
            let fileURL = path.appendingPathComponent(output)
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
//            return fileURL
        } catch {
            print("error creating file")
//            return nil
        }
    }
