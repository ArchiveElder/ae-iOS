//
//  PostViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/12.
//

import UIKit

class PostViewController: BaseViewController {
    
    lazy var postDataManager: PostDataManagerDelegate = PostDataManager()
    
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
    
    let doneButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        dismissButton()
        setDoneButton()
        keyboardDismissButton.isHidden = true
        setNavigationTitle(title: "글쓰기")
        doneButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        titleTextField.addTarget(self, action: #selector(editingStatusChanged), for: .editingChanged)
        categoryTextField.addTarget(self, action: #selector(editingStatusChanged), for: .editingChanged)
    }
    
    @objc func editingStatusChanged() {
        if isPostingAvailable() {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
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
    
    func setDoneButton() {
        let normalTitle = NSAttributedString(string: "완료", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.darkGreen])
        let disableTitle = NSAttributedString(string: "완료", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        doneButton.setAttributedTitle(normalTitle, for: .normal)
        doneButton.setAttributedTitle(disableTitle, for: .disabled)
        doneButton.addTarget(self, action: #selector(donePost), for: .touchUpInside)
        doneButton.frame = CGRect(x: 0, y: 0, width: 26, height: 20)
        let addDoneButton = UIBarButtonItem(customView: doneButton)
        
        self.navigationItem.setRightBarButton(addDoneButton, animated: false)
    }
    
    @objc func donePost() {
        presentAlert(title: "글쓰기를 완료하시겠어요?", message: nil, isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            self.postContent()
        })
    }
    
    func postContent() {
        showIndicator()
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""
        let groupName = categoryTextField.text ?? ""
        let postingInput = PostRequest(title: title, content: content, groupName: groupName)
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        
        postDataManager.postPosting(postingInput, multipartFileList: nil, userIdx: userId, delegate: self)
    }
    
    func isPostingAvailable() -> Bool {
        if titleTextField.text != "" && contentTextView.text != "" && categoryTextField.text != "" {
            return true
        }
        return false
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

extension PostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        editingStatusChanged()
        return true
    }
}

extension PostViewController: PostViewDelegate {
    func didSuccessPost(_ result: PostResponse) {
        dismissIndicator()
        self.dismiss(animated: true)
    }
    
    func failedToPost(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
    }
    
    
}
