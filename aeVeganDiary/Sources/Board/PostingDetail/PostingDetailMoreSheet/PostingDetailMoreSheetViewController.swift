//
//  PostingDetailMoreSheetViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import UIKit

class PostingDetailMoreSheetViewController: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var moreSheetView: UIView!
    
    @IBAction func editPostingButton(_ sender: Any) {
    }
    @IBAction func deletePostingButton(_ sender: Any) {
        presentAlert(title: "정말 삭제하시겠어요?", message: "삭제는 취소할 수 없습니다", isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            self.deletePostingDataManager.deletePosting(self.userIdx, postIdx: self.postIdx, parameters: DeletePostingRequest(), delegate: self)
        })
    }
    
    
    lazy var deletePostingDataManager : DeletePostingDataManager = DeletePostingDataManager()
    var userIdx = UserDefaults.standard.integer(forKey: "UserId")
    var postIdx : Int = 0
    
    var defaultHeight:CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moreSheetView.layer.cornerRadius = 15
        moreSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        moreSheetView.clipsToBounds = true
        
        heightConstraint.constant = view.frame.height
        
        print("바텀시트:", postIdx)
        
        dimmedView.alpha = 0.0
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        heightConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    // 4 - 1
            self.dimmedView.alpha = 0.7
                    // 4 - 2
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        heightConstraint.constant = safeAreaHeight+bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer:UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
}

extension PostingDetailMoreSheetViewController : DeletePostingViewDelegate{
    func didSuccessDeletePosting() {
        
        print("presentingViewController: ",presentingViewController)
        print("presentingViewController.presentingViewController: ",presentingViewController?.presentingViewController)
        /*
        if let first = presentingViewController,
                let second = first.presentingViewController{
                first.dismiss(animated: true)
                  second.dismiss(animated: true)
             }
        */
        
        //presentingViewController?.dismiss(animated: true)
        //navigationController?.popViewController(animated: true)
        
        let nav = self.presentingViewController
        self.dismiss(animated: true, completion: {
            
            //nav?.navigationController?.popToRootViewController(animated: true)
            nav?.dismiss(animated: true)
        })
    }
    
    func failedToRequest(message: String, code: Int) {
        
    }
    
    
}
