//
//  SelectTypeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/01.
//

import UIKit
import PhotosUI

class SelectTypeViewController: UIViewController {
    var rdate = ""
    var meal:Int? = nil
    
    let camera = UIImagePickerController()
    var pickerConfiguration = PHPickerConfiguration()
    
    // x 버튼 눌렀을 때
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // 촬영하기 눌렀을 때
    @IBAction func takePhotoButton(_ sender: Any) {
        self.camera.sourceType = .camera
        self.camera.allowsEditing = true
        self.camera.cameraDevice = .rear
        self.present(self.camera, animated: true, completion: nil)
    }
    
    // 사진 불러오기 눌렀을 때
    @IBAction func photoLibraryButton(_ sender: Any) {
        pickerConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        picker.modalPresentationStyle = .overFullScreen
        self.present(picker, animated: true)
    }
    
    // 검색하기 눌렀을 때
    @IBAction func searchButton(_ sender: Any) {
        let vc1 = SearchViewController()
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.view?.backgroundColor = .white
        nav1.modalPresentationStyle = .overFullScreen
        
        self.present(nav1, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.camera.delegate = self // picker delegate
    }

}

extension SelectTypeViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 갤러리에서 사진 선택하면 실행됨
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false) // 1
        let itemProvider = results.first?.itemProvider // 2

        if let itemProvider = itemProvider,
        itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    // 식단 등록하기 뷰로 넘어가면서 선택한 사진 전달
                    
                    let rootView = self.presentingViewController
                    self.dismiss(animated: false, completion: {
                        let vc = FoodRegisterViewController()
                        vc.foodImage = (image as? UIImage)!
                        vc.rdate = self.rdate
                        vc.meal = self.meal
                        let nav = UINavigationController(rootViewController: vc)
                        nav.view.backgroundColor = .white
                        nav.modalPresentationStyle = .fullScreen
                        
                        rootView?.present(nav, animated: true)
                    })
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage

        }
    }
    
    // 카메라로 사진 찍고 use photo 누르면 실행됨
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let rootView = self.presentingViewController
            self.dismiss(animated: false, completion: {
                let vc = FoodRegisterViewController()
                vc.foodImage = image
                vc.rdate = self.rdate
                vc.meal = self.meal
                let nav = UINavigationController(rootViewController: vc)
                nav.view.backgroundColor = .white
                nav.modalPresentationStyle = .fullScreen
                
                rootView?.present(nav, animated: true)
            })
        }
        
        
    }
}
