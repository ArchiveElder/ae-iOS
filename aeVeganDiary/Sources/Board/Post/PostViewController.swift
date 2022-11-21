//
//  PostViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/12.
//

import UIKit
import PhotosUI

class PostViewController: BaseViewController {
    
    lazy var postDataManager: PostDataManagerDelegate = PostDataManager()
    lazy var postEditDataManager: PostEditDataManagerDelegate = PostEditDataManager()
    
    let categories = ["일상", "레시피", "질문", "꿀팁"]
    var pickerView = UIPickerView()
    
    var isEditingPost = false
    var postIdx = 0
    var photoList:[UIImage] = []
    var pickerConfiguration = PHPickerConfiguration()
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var keyboardToolbarView: UIView!
    @IBOutlet weak var keyboardToolbarViewBottomConstraint: NSLayoutConstraint!
    @IBAction func photoButtonAction(_ sender: Any) {
        if photoList.count > 10 {
            presentAlert(message: "사진은 10개까지만 선택할 수 있어요")
        } else {
            pickerConfiguration.filter = .images
            pickerConfiguration.selectionLimit = 10 - photoList.count
            let picker = PHPickerViewController(configuration: pickerConfiguration)
            picker.delegate = self
            picker.modalPresentationStyle = .overFullScreen
            self.present(picker, animated: true)
        }
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
        setNavigationTitle(title: "글쓰기")
        doneButton.isEnabled = false
        editingStatusChanged()
        self.categoryTextField.text = categories[0]
        contentTextView.delegate = self
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        titleTextField.addTarget(self, action: #selector(editingStatusChanged), for: .editingChanged)
        categoryTextField.addTarget(self, action: #selector(editingStatusChanged), for: .editingChanged)
        categoryTextField.addTarget(self, action: #selector(hideDismissButton), for: .editingDidBegin)
        
        pickerView.delegate = self
        categoryTextField.inputView = pickerView
        
        photoCollectionView.register(UINib(nibName: "PostPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostPhotoCollectionViewCell")
    }
    
    @objc func editingStatusChanged() {
        if isPostingAvailable() {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    @objc func hideDismissButton() {
        keyboardDismissButton.isHidden = true
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
        if isEditingPost {
            let nav = self.presentingViewController
            self.dismiss(animated: true, completion: {
                nav?.dismiss(animated: true)
            })
        } else {
            presentAlert(title: "글쓰기를 취소하시겠어요?", message: "작성한 내용은 저장되지 않습니다.", isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
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
        let boardName = categoryTextField.text ?? ""
        let postingInput = PostRequest(title: title, content: content, boardName: boardName)
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        if self.isEditingPost {
            postEditDataManager.postEditing(postingInput, multipartFileList: photoList, userIdx: userId, postIdx: self.postIdx, delegate: self)
        } else {
            postDataManager.postPosting(postingInput, multipartFileList: photoList, userIdx: userId, delegate: self)
        }
    }
    
    func isPostingAvailable() -> Bool {
        if titleTextField.text != "" && contentTextView.text != "" && categoryTextField.text != "" {
            return true
        } else {
            return false
        }
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
    
    @objc func tapDone() {
        self.keyboardDismissButton.isHidden = false
        self.categoryTextField.resignFirstResponder()
    }
    
    @objc func deletePhoto(sender: UIButton) {
        photoList.remove(at: sender.tag)
        photoCollectionView.reloadData()
    }
    
    deinit {
        NotificationCenter().removeObserver(self)
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostPhotoCollectionViewCell", for: indexPath) as! PostPhotoCollectionViewCell
        cell.photoImageView.image = photoList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deletePhoto(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
}

extension PostViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if !(results.isEmpty)  {
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                self.photoList.append(image) // 5
                            }
                            self.photoCollectionView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
}

extension PostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        editingStatusChanged()
        return true
    }
}

extension PostViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
    }
}

extension PostViewController: PostViewDelegate {
    func didSuccessPost() {
        dismissIndicator()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func failedToPost(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
    }
    
    
}

extension PostViewController: PostEditViewDelegate {
    func didSuccessEdit() {
        dismissIndicator()
        
    }
    
    func failedToEdit(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
