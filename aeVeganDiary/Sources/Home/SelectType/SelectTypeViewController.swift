//
//  SelectTypeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/01.
//

import UIKit
import PhotosUI

class SelectTypeViewController: UIViewController {
    
    let camera = UIImagePickerController()
    var pickerConfiguration = PHPickerConfiguration()
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.camera.sourceType = .camera
            self.camera.allowsEditing = true
            self.camera.cameraDevice = .rear
            self.present(self.camera, animated: true, completion: nil)
        })
        
    }
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        pickerConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        picker.modalPresentationStyle = .overFullScreen
        self.present(picker, animated: true)
        
        /*guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true, completion: {
          pvc.present(picker, animated: true, completion: nil)
        })*/
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.camera.delegate = self // picker delegate
    }

}

extension SelectTypeViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false) // 1
        let itemProvider = results.first?.itemProvider // 2

        if let itemProvider = itemProvider,
        itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    let vc = FoodRegisterViewController()
                    vc.foodImage = (image as? UIImage)!
                    let nav = UINavigationController(rootViewController: vc)
                    nav.view.backgroundColor = .white
                    nav.modalPresentationStyle = .overFullScreen
                    
                    self.present(nav, animated: true)
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage

        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        picker.dismiss(animated: true, completion: {
            let vc = FoodRegisterViewController()
            vc.foodImage = possibleImage
            let nav = UINavigationController(rootViewController: vc)
            nav.view.backgroundColor = .white
            nav.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true)
        })
    }
}
