//
//  DetailBottomSheetViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/24.
//

import UIKit

class DetailBottomSheetViewController: UIViewController {

    lazy var deleteMealDataManager : DeleteMealDataManagerDelegate = DeleteMealDataManager()
    
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomSheetTopConstraint: NSLayoutConstraint!
    
    var defaultHeight: CGFloat = 120
    var meal: Int = 0
    
    @IBAction func editButtonAction(_ sender: Any) {
        guard let pvc = self.presentingViewController else { return }

        self.dismiss(animated: true) {
            let vc = FoodDetailEditViewController()
            vc.data = self.data
            vc.record_id = self.record_id
            vc.meal = self.meal
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .fullScreen
            nvc.view.backgroundColor = .white
            self.present(nvc, animated: true)
            pvc.present(nvc, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func deleteButtonAction(_ sender: Any) {
        presentAlert(title: "정말 삭제하시겠어요?", message: "삭제는 취소할 수 없습니다", isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            var input = DeleteMealRequest(recordId: self.record_id)
            self.deleteMealDataManager.deleteMealData(input, delegate: self)
        })
    }
    
    var data: DetailRecord?
    var record_id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomSheetView.layer.cornerRadius =  15
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.clipsToBounds = true
        
        bottomSheetTopConstraint.constant = view.frame.height
        
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
        
        bottomSheetTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
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
        bottomSheetTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }

}

//presentingViewController:  Optional(<UINavigationController: 0x109034a00>)
//presentingViewController.presentingViewController:  Optional(<aeVeganDiary.BaseTabBarController: 0x104818600>)

//presentingViewController:  Optional(<aeVeganDiary.BaseTabBarController: 0x104818600>)
//presentingViewController.presentingViewController:  nil


extension DetailBottomSheetViewController : DeleteMealViewDelegate{
    func didSuccessDeleteMeal(_ result: DeleteMealResponse) {
        print("presentingViewController: ",presentingViewController)
        print("presentingViewController.presentingViewController: ",presentingViewController?.presentingViewController)
        if let first = presentingViewController,
                let second = first.presentingViewController{
                  first.view.isHidden = true
                  second.dismiss(animated: true)
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
