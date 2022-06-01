//
//  SelectTypeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/01.
//

import UIKit
import PhotosUI

class SelectTypeViewController: UIViewController, PHPickerViewControllerDelegate {
    
    let camera = UIImagePickerController()
    var pickerConfiguration = PHPickerConfiguration()
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        present(camera, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        pickerConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        //imagePicker.modalPresentationStyle = .overFullScreen
        //self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.camera.delegate = self // picker delegate
        
    }

}

extension SelectTypeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        picker.dismiss(animated: true, completion: {
            let vc = FoodRegisterViewController()
            vc.foodImage = possibleImage
            let nav = UINavigationController(rootViewController: vc)
            nav.view.backgroundColor = .white
            nav.modalPresentationStyle = .overFullScreen
            
            self.present(nav, animated: true)
        })

        picker.dismiss(animated: true, completion: nil)
    }
}
