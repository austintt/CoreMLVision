//
//  ViewController.swift
//  MachineVisionExample
//
//  Created by Austin Tooley on 6/8/17.
//  Copyright © 2017 Austin Tooley. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topGuess: UILabel!
    @IBOutlet weak var secondGuess: UILabel!
    @IBOutlet weak var thirdGuess: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makePredictions(image: UIImage) {
        do {
            let model = try VNCoreMLModel(for: Inceptionv3().model)
            let request = VNCoreMLRequest(model: model, completionHandler: displayPredictions)
            let handler = VNImageRequestHandler(cgImage: image.cgImage!)
            try handler.perform([request])
        } catch {
    
        }
    }
        
    func displayPredictions(request: VNRequest, error: Error?) {
        // Make sure we have a result
        guard let results = request.results as? [VNClassificationObservation]
            else { fatalError("Bad prediction") }
        
        // Sort results by confidence
        results.sorted(by: {$0.confidence > $1.confidence})
        
        // Show prediction results
        topGuess.text = "\(results[0].identifier) - \(results[0].confidence * 100)%"
        secondGuess.text = "\(results[1].identifier) - \(results[1].confidence * 100)%"
        thirdGuess.text = "\(results[2].identifier) - \(results[2].confidence * 100)%"
    }
        
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else { fatalError("no image from image picker") }
        
        // Show the image in the UI.
        imageView.image = uiImage
        
        // Make prediction
        makePredictions(image: uiImage)
    }

    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true)
        }
    }
    
    @IBAction func openPicker(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
}

