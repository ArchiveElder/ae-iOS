//
//  PopUpViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/30.
//

import UIKit

class PopUpViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        
    }
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        imagePicker.modalPresentationStyle = .overFullScreen
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
        self.imagePicker.allowsEditing = false // 수정 가능 여부
        self.imagePicker.delegate = self // picker delegate
        
    }

}

extension PopUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker == imagePicker {
            //var newImage: UIImage? = nil // update 할 이미지
            
            let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    
            print(possibleImage)
            
            picker.dismiss(animated: true, completion: {
                let vc = FoodRegisterViewController()
                
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.view.backgroundColor = .white
                
                self.present(nav, animated: true)
            })
        }
        
    }
}
