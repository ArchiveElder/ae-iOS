//
//  FoodDetailEditViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/24.
//

import UIKit
import PhotosUI

class FoodDetailEditViewController: BaseViewController {
    
    lazy var foodDetailEditDataManager: FoodDetailEditDataManagerDelegate = FoodDetailEditDataManager()

    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var caloryTextField: UITextField!
    @IBOutlet weak var carbTextField: UITextField!
    @IBOutlet weak var proTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    
    @IBOutlet weak var foodImageView: UIImageView!
    var data: DetailRecord?
    var record_id: Int?
    var meal: Int = 0
    
    var pickerConfiguration = PHPickerConfiguration()
    
    @IBAction func imageEditButtonAction(_ sender: Any) {
        pickerConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        picker.modalPresentationStyle = .overFullScreen
        self.present(picker, animated: true)
    }
    
    @IBAction func imageDeleteButtonAction(_ sender: Any) {
        self.foodImageView.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dismissKeyboardWhenTappedAround()
        
        mealLabel.text = data?.text
        dateLabel.text = data?.date
        
        nameTextField.text = data?.text
        caloryTextField.text = data?.cal
        carbTextField.text = data?.carb
        proTextField.text = data?.protein
        fatTextField.text = data?.fat
        amountTextField.text = "\(data?.amount ?? 0)"
        
        if let url = URL(string: data?.image_url ?? "") {
            foodImageView.load(url: url)
        }
        
        setNavigationTitle(title: "수정하기")
        setDismissButton()
        setDoneButton()
    }
    
    func setDoneButton() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(done))
        
        self.navigationItem.setRightBarButton(doneButton, animated: false)
    }
    
    @objc func done() {
        showIndicator()
        let input = FoodDetailEditRequest(recordId: self.record_id ?? 0, text: nameTextField.text, calory: caloryTextField.text, carb: carbTextField.text, protein: proTextField.text, fat: fatTextField.text, rdate: data?.date, rtime: data?.time, amount: data?.amount, meal: self.meal)
        print(input)
        foodDetailEditDataManager.postFoodDetailEdit(input, foodImage: foodImageView.image, delegate: self)
    }

}

extension FoodDetailEditViewController: FoodDetailEditViewDelegate {
    func didSuccessFoodDetailEdit(_ result: RegisterResponse) {
        dismissIndicator()
        presentAlert(message: "수정 완료")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.dismiss(animated: true)
        }
    }
    
    func failedToRequest(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
        if code == 403 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.changeRootViewController(LoginViewController())
            }
        }
    }
}

extension FoodDetailEditViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 갤러리에서 사진 선택하면 실행됨
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false) // 1
        let itemProvider = results.first?.itemProvider // 2

        if let itemProvider = itemProvider,
        itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    self.foodImageView.image = image as? UIImage
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage

        }
    }
}
