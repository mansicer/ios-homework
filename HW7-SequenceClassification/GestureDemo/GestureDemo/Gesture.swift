//
//  Gesture.swift
//  GestureDemo
//
//  Created by sicer on 2021/1/24.
//

import Foundation
import CoreML
import CoreMotion

class Gesture : ObservableObject {
    // Config enum stores constants that control app behavior
    enum Config {
        static let samplesPerSecond = 25.0
        static let numberOfFeatures = 6
        static let windowSize = 20
        static let windowOffset = 5
        static let numberOfWindows = windowSize / windowOffset
        static let bufferSize = windowSize + windowOffset * (numberOfWindows - 1)
        
        static let doubleSize = MemoryLayout<Double>.stride
        static let windowSizeAsBytes = doubleSize * numberOfFeatures * windowSize
        static let windowOffsetAsBytes = doubleSize * numberOfFeatures * windowOffset
    }
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1 / Config.samplesPerSecond
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: operationQueue, withHandler: {
            [weak self] motionData, error in
            guard let self = self, let motionData = motionData else {
                if let error = error {
                    fatalError("Device Motion update error \(error)")
                } else {
                    fatalError("Device Motion update error with no error message")
                }
            }
            self.buffer(motionData: motionData)
            if self.bufferIndex == 0 {
                self.isDataAvailable = true
            }
            self.predict()
            print("\(self.motionResult) \(self.motionConfidence)")
            
        })
    }
    
    static private func makeMLMultiArray(numberOfSamples: Int) -> MLMultiArray? {
        try? MLMultiArray(shape: [1, numberOfSamples, Config.numberOfFeatures] as [NSNumber], dataType: .double)
    }
    
    let model = try! GestureClassifier(configuration: MLModelConfiguration())
    let motionManager = CMMotionManager()
    let operationQueue = OperationQueue()
    
    let modelInput: MLMultiArray! = makeMLMultiArray(numberOfSamples: Config.windowSize)
    let dataBuffer: MLMultiArray! = makeMLMultiArray(numberOfSamples: Config.bufferSize)
    var modelOutput: GestureClassifierOutput!
    
    var bufferIndex = 0
    var isDataAvailable = false
    
    @Published var lastMotionResult: String = "初始化..."
    @Published var motionResult: String = "初始化..."
    @Published var motionConfidence: String = "初始化..."
    
    func buffer(motionData: CMDeviceMotion) {
        for offset in [0, Config.windowSize] {
            let index = bufferIndex + offset
            if index >= Config.bufferSize {
                continue
            }
            addToBuffer(index, 0, motionData.rotationRate.x)
            addToBuffer(index, 1, motionData.rotationRate.y)
            addToBuffer(index, 2, motionData.rotationRate.z)
            addToBuffer(index, 3, motionData.userAcceleration.x)
            addToBuffer(index, 4, motionData.userAcceleration.y)
            addToBuffer(index, 5, motionData.userAcceleration.z)
        }
        bufferIndex = (bufferIndex + 1) % Config.windowSize
    }
    
    private func addToBuffer(_ index1: Int, _ index2: Int, _ data: Double) {
        let index = [0, index1, index2] as [NSNumber]
        dataBuffer[index] = data as NSNumber
    }
    
    func predict() {
        if isDataAvailable && bufferIndex % Config.windowOffset == 0 && bufferIndex + Config.windowOffset <= Config.windowSize {
            let window = bufferIndex / Config.windowOffset
            memcpy(modelInput.dataPointer, dataBuffer.dataPointer.advanced(by: window * Config.windowOffsetAsBytes), Config.windowSizeAsBytes)
            var input: GestureClassifierInput! = nil
            if let output = modelOutput {
                input = GestureClassifierInput(features: modelInput, hiddenIn: output.hiddenOut, cellIn: output.hiddenOut)
            } else {
                input = GestureClassifierInput(features: modelInput)
            }
            do {
                modelOutput = try model.prediction(input: input)
            } catch {
                fatalError("Prediction failed! \(error)")
            }
            DispatchQueue.main.async {
                if self.motionResult != self.modelOutput.activity {
                    self.lastMotionResult = self.motionResult
                }
                self.motionResult = self.modelOutput.activity
                self.motionConfidence = String(format: "%.4f", self.modelOutput.activityProbability[self.motionResult]!)
            }
        }
    }
}
