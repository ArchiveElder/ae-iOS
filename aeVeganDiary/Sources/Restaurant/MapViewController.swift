//
//  MapViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/25.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showBottomSheet(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func showBottomSheet(_ tapRecognizer: UITapGestureRecognizer) {
        let vc = BottomViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
}


