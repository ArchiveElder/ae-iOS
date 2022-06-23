//
//  UITextField.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/03.
//

import Foundation
import UIKit

extension UITextField {
    
    // datePicker 설정
    func setInputViewDatePicker(target: Any, selector: Selector, datePicker: UIDatePicker, dateFormatter: DateFormatter) {
        // Create a UIDatePicker object and assign to inputView
        
        let date = dateFormatter.date(from: self.text ?? "")
        datePicker.date = date ?? Date()
        
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
