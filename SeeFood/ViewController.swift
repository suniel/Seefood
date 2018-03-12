//
//  ViewController.swift
//  SeeFood
//
//  Created by Suniel on 11/7/17.
//  Copyright © 2017 Suniel. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Please Use your own api key
    let apiKey = ""
    let version = "2017-11-07"
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var hotornotImage: UIImageView!
	@IBOutlet weak var shareButton: UIButton!
	
	let imagePicker = UIImagePickerController()
    var classificationResults: [String] = [String]()
    
    override func viewDidLoad() {
		super.viewDidLoad()
		imagePicker.delegate = self
	}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
        cameraButton.isEnabled = false
        SVProgressHUD.show()
        
        if let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = imageSelected
            picker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
            
            let imageData = UIImageJPEGRepresentation(imageSelected, 0.01)
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = documentsUrl.appendingPathComponent("tempImage.jpg")
            
            try? imageData?.write(to: fileUrl)
            
            visualRecognition.classify(imageFile: fileUrl, success: { (classifiedImages) in
                
                //print(classifiedImages)
                self.classificationResults = []
                
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                for index in 1..<classes.count{
                    self.classificationResults.append(classes[index].classification)
                }
				
				//print(self.classificationResults)
				
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.cameraButton.isEnabled = true
                }
                
                if self.classificationResults.contains("pasta"){
                    DispatchQueue.main.async {
						self.navigationController?.navigationBar.barTintColor = UIColor(red:0.57, green:0.86, blue:0.35, alpha:1.0)
						self.navigationController?.navigationBar.tintColor = UIColor.white
						self.hotornotImage.image = UIImage(named: "checked")
                        self.navigationItem.title = "Pasta!"
						self.navigationController?.navigationBar.isTranslucent = false
                    }
                } else {
                    DispatchQueue.main.async {
						self.navigationController?.navigationBar.barTintColor = UIColor(red:0.85, green:0.00, blue:0.15, alpha:1.0)
						self.navigationController?.navigationBar.tintColor = UIColor.white
						self.hotornotImage.image = UIImage(named: "cancel")
                        self.navigationItem.title = "Not Pasta!"
						self.navigationController?.navigationBar.isTranslucent = false 
                    }
                }
                
            })
            
        } else {
            print("There was an error")
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //print("Open up my camera.")
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
	@IBAction func shareTapped(_ sender: UIButton) {
		print("Share now")
	}
	
}

