//
//  ViewController.swift
//  SnackLocalization
//
//  Created by 张福翔 on 2021/1/22.
//

import UIKit
import CoreMedia
import CoreML
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var regionRectangle: RegionRectangle? = nil
    var classLabel: UILabel = UILabel()
    
    static let labels = ["apple", "banana", "cake", "candy", "carrot", "cookie",
                         "doughnut", "grape", "hot dog", "ice cream", "juice",
                         "muffin", "orange", "pineapple", "popcorn", "pretzel",
                         "salad", "strawberry", "waffle", "watermelon"]
    
    
    var videoCapture: VideoCapture!
    var semaphore = DispatchSemaphore(value: ViewController.maxInflightBufferSize)
    var inflightBufferSize = 0
    static let maxInflightBufferSize = 2
    
    lazy var predictionRequest: VNCoreMLRequest = {
        do {
            let snackLocalization = try SnackLocalization(configuration: MLModelConfiguration())
            let model = try VNCoreMLModel(for: snackLocalization.model)
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                self?.processObservation(for: request, error: error)
            }
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("cannot create ML request, Error: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCamera()
        self.view.addSubview(classLabel)
    }
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        
        videoCapture.frameInterval = 1
        videoCapture.setUp(sessionPreset: .high) { success in
            guard success else {
                fatalError("Video setup do not succeed")
            }
            guard let previewLayer = self.videoCapture.previewLayer else {
                fatalError("can not get preview layer")
            }
            self.imageView.layer.addSublayer(previewLayer)
            self.videoCapture.previewLayer?.frame = self.imageView.bounds
            self.videoCapture.start()
        }
    }

}

extension ViewController: VideoCaptureDelegate {
    func videoCapture(capture: VideoCapture, didCaptureVideoFrame: CMSampleBuffer) {
        predict(sampleBuffer: didCaptureVideoFrame)
    }
    
    func predict(sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            fatalError("cannot create sample buffer")
        }
        semaphore.wait()
        inflightBufferSize += 1
        if inflightBufferSize >= ViewController.maxInflightBufferSize {
            inflightBufferSize = 0
        }
        DispatchQueue.main.async {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            do {
                try handler.perform([self.predictionRequest])
            } catch {
                fatalError("perform prediction failed, Error: \(error)")
            }
            self.semaphore.signal()
        }
    }
    
    func processObservation(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNCoreMLFeatureValueObservation] {
            let pred = (results.first?.featureValue.multiArrayValue)!
            var maxLabel = 0
            var maxNum = pred[0] as! Double
            for i in 0..<pred.count {
                if pred[i] as! Double > maxNum {
                    maxNum = pred[i] as! Double
                    maxLabel = i
                }
            }
            let label = ViewController.labels[maxLabel]
            let score = maxNum
            let loc = (results.last?.featureValue.multiArrayValue)!
            let xmin = loc[0] as! CGFloat, xmax = loc[1] as! CGFloat, ymin = loc[2] as! CGFloat, ymax = loc[3] as! CGFloat
            
            let width = imageView.frame.width
            let height = imageView.frame.height
            let x = width * xmin
            let y = height * ymin
            let w = width * (xmax - xmin)
            let h = height * (ymax - ymin)
            
            classLabel.frame = CGRect(x: x, y: y-20, width: 300, height: 20)
            classLabel.text = "\(label) \(String(format: "%.3f", score))"
            
            let rec = CGRect(x: x, y: y, width: w, height: h)
            if let recView = self.regionRectangle {
                recView.removeFromSuperview()
            }
            regionRectangle = RegionRectangle(frame: rec)
            imageView.addSubview(regionRectangle!)
        }
    }
}

class RegionRectangle: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        UIColor(red: 255, green: 0, blue: 0, alpha: 0.3).setFill()
        UIRectFill(rect)
    }
}
