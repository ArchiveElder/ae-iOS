//
//  IndicatorView.swift
//  aeVeganDiary
//
//  Created by κΆνμ on 2022/05/28.
//

import UIKit

open class IndicatorView {
    static let shared = IndicatorView()
        
    let containerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    open func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.containerView.frame = window.frame
        self.containerView.center = window.center
        self.containerView.backgroundColor = .clear
        
        self.containerView.addSubview(self.activityIndicator)
        //UIApplication.shared.windows.first?.addSubview(self.containerView)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window1 = windowScene?.windows.first
        window1?.addSubview(self.containerView)
    }
    
    open func showIndicator() {
        self.containerView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        self.activityIndicator.style = .large
        self.activityIndicator.color = .white
        self.activityIndicator.center = self.containerView.center
        
        self.activityIndicator.startAnimating()
    }
    
    open func dismiss() {
        self.activityIndicator.stopAnimating()
        self.containerView.removeFromSuperview()
    }
}
