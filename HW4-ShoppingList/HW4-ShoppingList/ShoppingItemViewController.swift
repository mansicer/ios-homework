//
//  ShoppingItemViewController.swift
//  HW4-ShoppingList
//
//  Created by 张福翔 on 2020/11/3.
//

import UIKit
import CoreML
import Vision
import ImageIO
import os.log

class ShoppingItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: properties
    var item: ShoppingItem?
    private var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        reasonTextField.delegate = self
        imagePickerController.delegate = self
        
        if let item = self.item {
            navigationItem.title = item.name
            nameTextField.text = item.name
            photoImageView.image = item.photo
            ratingPickerView.rating = item.rating
            reasonTextField.text = item.reason
        }
        ratingPickerView.isActive = true
        saveButton.isEnabled = !(nameTextField.text?.isEmpty ?? true)
    }
    
    // MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingPickerView: RatingPickerView!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === nameTextField {
            saveButton.isEnabled = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === nameTextField {
            saveButton.isEnabled = !(textField.text?.isEmpty ?? true)
            navigationItem.title = textField.text
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        photoImageView.image = selectedImage
        if let image = selectedImage {
            updateClassification(for: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func selectPhoto(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let alert = UIAlertController(title: "选择图片来源", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "相机", style: .default, handler: {_ in self.openCarera()}))
        }
        alert.addAction(UIAlertAction(title: "照片图库", style: .default, handler: {_ in self.openGallery()}))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = photoImageView
            alert.popoverPresentationController?.sourceRect = photoImageView.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: private methods
    private func openCarera() {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func openGallery() {
        imagePickerController.sourceType = .savedPhotosAlbum
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        // behavior of saving
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingPickerView.rating
        let reason = reasonTextField.text
        
        item = ShoppingItem(name: name, photo: photo, rating: rating, reason: reason)
    }
    
    
    // MARK: ML things
    lazy var predictionRequest: VNCoreMLRequest? = {
        do {
            let model = try VNCoreMLModel(for: MobileNetV2().model)
            let request = VNCoreMLRequest(model: model, completionHandler: {request, error in self.processRequest(for: request, error: error)})
            request.imageCropAndScaleOption = .scaleFit
            return request
        } catch {
            os_log("cannot use CoreML model", log: OSLog.default, type: .debug)
            return nil
        }
    } ()
    private func updateClassification(for image: UIImage) {
        if let request = predictionRequest {
            let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
            let ciImage = CIImage(image: image)!
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
                do {
                    try handler.perform([request])
                } catch {
                    print("cannot perform classification")
                }
            }
        }
    }
    private func processRequest(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let result = request.results else {
                return
            }
            let cls = result as! [VNClassificationObservation]
            if cls.isEmpty {
                return
            } else {
                self.nameTextField.text = cls.first?.identifier
            }
        }
    }
}

