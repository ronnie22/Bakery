//
//  ViewController.swift
//  Bakery
//
//  Created by Raunak Sinha on 04/10/19.
//  Copyright © 2019 Raunak Sinha. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var doughnutLabel: UILabel!
    
    @IBOutlet weak var bagelLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            processImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func processImage(image: UIImage){
        
        if let model = try? VNCoreMLModel(for: BakeryClassifier().model) {
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation]{
                    for result in results {
                        // print("\(result.identifier): \(result.confidence * 100)%")
                        if result.identifier == "bagels" {
                            let num = (result.confidence * 100.0).rounded()
                            self.bagelLabel.text = "\(Int(num))%"
                        }
                        if result.identifier == "doughnuts" {
                            let num = (result.confidence * 100.0).rounded()
                            self.doughnutLabel.text = "\(Int(num))%"
                        }
                    }
                }
            }
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
                
            }
        }
    }
    
    @IBAction func choosePhotoTapped(_ sender: Any) {
        
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
        
    }
    
}

