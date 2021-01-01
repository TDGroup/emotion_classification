//
//  SVMTests.swift
//  emotion
//
//  Created by Thu on 12/30/20.
//  Copyright © 2020 Pro. All rights reserved.
//

@testable import EmotionClassification
import XCTest
//import AIToolbox

class SVMTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmotion(){
        let input : [[Double]] = [
        [0.8970727079074751,1.0745658363942265,0.33536663950961976,0.3623031356610541,0.18619513878035915,0.22715906855500148,0.12524857523713462,0.16104824777901564,0.08185077946370577,0.10266541783469066],
        [0.4869941536122436,0.7486503377829717,0.3245021856772289,0.35041762605365917,0.1616236668382276,0.21723895593984238,0.12060805847840857,0.13092925074423395,0.08517490616897949,0.11379543221672186],
        [1.7229102910168048,2.0276863894728945,1.0003249100627616,1.2356505661628125,0.5165945976664407,0.6749320446918605,0.24994709617055771,0.2888958817876349,0.10979701487408189,0.13354929948852712],
        [0.27717533845439957,0.36749697176964724,0.6396345067925671,0.6062567240484161,0.21319126031017976,0.27711295530160945,0.13011593640729027,0.1256534885908389,0.0674196654377112,0.09466792103559132],
        [0.5657291705881926,0.6661976673377629,0.5620990879593578,0.6052535199429381,0.26772523966495776,0.31888386146648584,0.20793328381826545,0.23383545488196888,0.16695148586614084,0.21998956098449293]
        ]
        let c = emotion(input)

        print(c) // true: 1,1,1,1,0,0,0,0
//        createCSV(from: input, output: "test.csv")
//        let e = Emotion()
//        let a = e.get_csv(path: "test.csv")
//        print (a)
    }

    func testClassification() {
        //  Create a data set
        let data = DataSet(dataType: .Classification, inputDimension: 10, outputDimension: 1)
        do {
//            try data.addDataPoint(input: [0.0, 1.0], output:1)
//            try data.addDataPoint(input: [0.0, 0.9], output:1)
//            try data.addDataPoint(input: [0.1, 1.0], output:1)
//            try data.addDataPoint(input: [1.0, 0.0], output:0)
//            try data.addDataPoint(input: [1.0, 0.1], output:0)
//            try data.addDataPoint(input: [0.9, 0.0], output:0)
            
            try data.addDataPoint(input: [1.589436256399878999e+01,3.575284387545330844e+01,1.362662428274136595e+01,2.711292528541476798e+01,6.037295889899306545e+00,1.113378764469528903e+01,2.462127071378845233e+00,3.982262758710940265e+00,1.340950983368172311e+00,2.015474623645287622e+00], output:0)
            try data.addDataPoint(input: [2.631761491809043108e+01,3.374857467819095547e+01,1.530895762828522244e+01,2.632965670053811991e+01,7.572465074716618005e+00,1.292485638055264907e+01,2.313387559211483424e+00,4.316582052028194560e+00,1.651272018769052385e+00,2.272113428262144463e+00], output:1)
            try data.addDataPoint(input: [6.725132915166018854e+00,1.158262487583841782e+01,3.596637607989214835e+00,9.171489941558988335e+00,3.208925190742135225e+00,6.538195992844720195e+00,2.252059646645015345e+00,4.079241120632443263e+00,1.534294710622795987e+00,2.410977188605269106e+00], output:0)
            try data.addDataPoint(input: [2.918865384607052604e+01,4.372958657408747740e+01,1.545189275034774568e+01,2.739874584530342361e+01,5.949998549922081992e+00,1.101237039731849698e+01,2.809087735194293778e+00,5.689702645511848900e+00,2.895629422715700230e+00,3.861982585981419636e+00], output:0)
            try data.addDataPoint(input: [1.589744498620005686e+01,2.759688745963964607e+01,1.325105045381709878e+01,2.207491922463588807e+01,5.523342265720598832e+00,9.881582866758932937e+00,2.463269333854395171e+00,4.474479631862074314e+00,1.773666638097737280e+00,2.797192807066331444e+00], output:0)
            try data.addDataPoint(input: [1.070331162771950240e+01,2.403044893257206382e+01,9.111161289264416041e+00,1.557503733894812292e+01,3.466386552533255117e+00,8.518576750772352213e+00,2.196156382272838492e+00,4.288036558957795563e+00,1.723001360088983303e+00,2.889845435412516483e+00], output:1)
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Create an SVM classifier and train
        let svm = SVMModel(problemType: .C_SVM_Classification, kernelSettings:
                    KernelParameters(type: .RadialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
        svm.train(data: data)
        
        //  Create a test dataset
        let testData = DataSet(dataType: .Classification, inputDimension: 10, outputDimension: 1)
        do {
            try testData.addTestDataPoint(input: [1.577147533935229440e+01,3.078655699651216437e+01,1.141344905016920741e+01,2.245654057262630943e+01,5.567196450349632286e+00,9.390451961460774655e+00,2.190010034989024135e+00,3.691081131137141647e+00,1.912901009894842241e+00,2.726295326264132513e+00])    //  Expect 0
            try testData.addTestDataPoint(input: [1.230559372307805610e+01,2.239427088908824359e+01,7.162060008981036674e+00,1.650960254033024555e+01,4.047301067494347038e+00,8.025792116234130802e+00,1.666351293603037131e+00,3.094654759908791686e+00,1.800232474585446107e+00,2.528204219863461777e+00])    //  Expect 0
//            try testData.addTestDataPoint(input: [1.0, 0.9])    //  Expect 0
//            try testData.addTestDataPoint(input: [0.9, 1.0])    //  Expect 1
//            try testData.addTestDataPoint(input: [0.5, 0.4])    //  Expect 0
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
            XCTAssert(classLabel == 0, "first test data point, expect 0")
            try classLabel = testData.getClass(index: 1)
            XCTAssert(classLabel == 0, "second test data point, expect 0")
//            try classLabel = testData.getClass(index: 2)
//            XCTAssert(classLabel == 0, "third test data point, expect 0")
//            try classLabel = testData.getClass(index: 3)
//            XCTAssert(classLabel == 1, "fourth test data point, expect 1")
//            try classLabel = testData.getClass(index: 4)
//            XCTAssert(classLabel == 0, "fifth test data point, expect 0")
//            try classLabel = testData.getClass(index: 5)
//            XCTAssert(classLabel == 1, "sixth test data point, expect 1")
        }
        catch {
            print("Error in prediction")
        }

//  Test persistence routines
//        let path = "SomeValidWritablePath"
//        do {
//            try svm.saveToFile(path)
//        }
//        catch {
//            print("Error in writing file")
//        }
//        let readSVM = SVMModel(loadFromFile: path)
//        if let readSVM = readSVM {
//            readSVM.predictValues(testData)
//
//            //  See if we matched
//            var classLabel : Int
//            do {
//                try classLabel = testData.getClass(0)
//                XCTAssert(classLabel == 1, "first test data point, expect 1")
//                try classLabel = testData.getClass(1)
//                XCTAssert(classLabel == 0, "second test data point, expect 0")
//                try classLabel = testData.getClass(2)
//                XCTAssert(classLabel == 0, "third test data point, expect 0")
//                try classLabel = testData.getClass(3)
//                XCTAssert(classLabel == 1, "fourth test data point, expect 1")
//                try classLabel = testData.getClass(4)
//                XCTAssert(classLabel == 0, "fifth test data point, expect 0")
//                try classLabel = testData.getClass(5)
//                XCTAssert(classLabel == 1, "sixth test data point, expect 1")
//            }
//            catch {
//                print("Error in prediction with read SVM")
//            }
//        }
    }
    
    func testThreeStateClassification() {
        //  Create a data set
        let data = DataSet(dataType: .Classification, inputDimension: 2, outputDimension: 1)
        do {
            try data.addDataPoint(input: [0.2, 0.9], output:0)
            try data.addDataPoint(input: [0.8, 0.3], output:0)
            try data.addDataPoint(input: [0.5, 0.6], output:0)
            try data.addDataPoint(input: [0.2, 0.7], output:1)
            try data.addDataPoint(input: [0.2, 0.3], output:1)
            try data.addDataPoint(input: [0.4, 0.5], output:1)
            try data.addDataPoint(input: [0.5, 0.4], output:2)
            try data.addDataPoint(input: [0.3, 0.2], output:2)
            try data.addDataPoint(input: [0.7, 0.2], output:2)
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Create an SVM classifier and train
        let svm = SVMModel(problemType: .C_SVM_Classification, kernelSettings:
            KernelParameters(type: .RadialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
        svm.train(data: data)
        
        //  Create a test dataset
        let testData = DataSet(dataType: .Classification, inputDimension: 2, outputDimension: 1)
        do {
            try testData.addTestDataPoint(input: [0.7, 0.6])    //  Expect 0
            try testData.addTestDataPoint(input: [0.5, 0.7])    //  Expect 0
            try testData.addTestDataPoint(input: [0.1, 0.6])    //  Expect 1
            try testData.addTestDataPoint(input: [0.1, 0.4])    //  Expect 1
            try testData.addTestDataPoint(input: [0.3, 0.1])    //  Expect 2
            try testData.addTestDataPoint(input: [0.7, 0.1])    //  Expect 2
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
            XCTAssert(classLabel == 0, "first test data point, expect 0")
            try classLabel = testData.getClass(index: 1)
            XCTAssert(classLabel == 0, "second test data point, expect 0")
            try classLabel = testData.getClass(index: 2)
            XCTAssert(classLabel == 1, "third test data point, expect 1")
            try classLabel = testData.getClass(index: 3)
            XCTAssert(classLabel == 1, "fourth test data point, expect 1")
            try classLabel = testData.getClass(index: 4)
            XCTAssert(classLabel == 2, "fifth test data point, expect 2")
            try classLabel = testData.getClass(index: 5)
            XCTAssert(classLabel == 2, "sixth test data point, expect 2")
        }
        catch {
            print("Error in prediction")
        }
    }
    
    func testRegression() {
        //  Create a data set - function is x1*2 - x2
        let data = DataSet(dataType: .Regression, inputDimension: 2, outputDimension: 1)
        do {
            try data.addDataPoint(input: [0.0, 1.0], output:[-1.0])
            try data.addDataPoint(input: [0.0, 0.5], output:[-0.5])
            try data.addDataPoint(input: [0.0, 0.0], output:[0.0])
            try data.addDataPoint(input: [0.5, 1.0], output:[0.0])
            try data.addDataPoint(input: [0.5, 0.5], output:[0.5])
            try data.addDataPoint(input: [0.5, 0.0], output:[1.0])
            try data.addDataPoint(input: [1.0, 1.0], output:[1.0])
            try data.addDataPoint(input: [1.0, 0.5], output:[1.5])
            try data.addDataPoint(input: [1.0, 0.0], output:[2.0])
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Create an SVM regularizer and train
        let svm = SVMModel(problemType: .ϵSVMRegression, kernelSettings:
            KernelParameters(type: .RadialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
        svm.train(data: data)
        
        //  Create a test dataset - same function
        let testData = DataSet(dataType: .Regression, inputDimension: 2, outputDimension: 1)
        do {
            try testData.addTestDataPoint(input: [0.5, 0.5])    //  Expect 0.5
//            try testData.addTestDataPoint(input: [0.8, 0.0])    //  Expect 0.64
//            try testData.addTestDataPoint(input: [1.0, 0.8])    //  Expect 0.2
//            try testData.addTestDataPoint(input: [0.8, 1.0])    //  Expect -0.36
//            try testData.addTestDataPoint(input: [0.2, 0.0])    //  Expect 0.04
//            try testData.addTestDataPoint(input: [0.5, 0.1])    //  Expect 0.15
        }
        catch {
            print("Invalid data set created")
        }
        
        //  Predict on the test data
        svm.predictValues(data: testData)
        
        //  See if we matched
        if let testOut = testData.singleOutput(index: 0) {
            let diff = testOut - 0.5
            XCTAssert(fabs(diff) < 0.01, "first test data point, expect -0.8")
        }
        else {
            XCTAssert(false, "first test data point, no value")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
