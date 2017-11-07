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
    let apiKey = "8797fe26f2deefa46303df2eb02f21ca3f4720e1"
    let version = "2017-11-07"
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var classificationResults: [String] = [String]()
    
    override func viewDidLoad() {
		super.viewDidLoad()
		imagePicker.delegate = self
	}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
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
                print(self.classificationResults)
                if self.classificationResults.contains("hotdog"){
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Hotdog!"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog!"
                    }
                }
                
            })
            
        } else {
            print("There was an error")
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        print("Open up my camera.")
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    

}

