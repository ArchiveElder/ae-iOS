//
//  PostViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/12.
//

import UIKit

class PostViewController: BaseViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var keyboardToolbarView: UIView!
    @IBOutlet weak var keyboardToolbarViewBottomConstraint: NSLayoutConstraint!
    @IBAction func photoButtonAction(_ sender: Any) {
    }
    @IBOutlet weak var keyboardDismissButton: UIButton!
    @IBAction func keyboardDismissButtonAction(_ sender: Any) {
        dismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        dismissButton()
        keyboardDismissButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 뒤로가기/중간이탈 버튼 추가
    func dismissButton() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissAndGoBack), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
    }
    
    // 뒤로가기/중간이탈 모달
    @objc func dismissAndGoBack() {
        presentAlert(title: "글쓰기를 취소하시겠어요?", message: "작성한 내용은 저장되지 않습니다.", isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            if isKeyboardShowing {
                keyboardDismissButton.isHidden = false
            } else {
                keyboardDismissButton.isHidden = true
            }
            
            keyboardToolbarViewBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter().removeObserver(self)
    }
}
