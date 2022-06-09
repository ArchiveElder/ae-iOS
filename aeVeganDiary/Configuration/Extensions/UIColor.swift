//
//  UIColor.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var mainGreen: UIColor { UIColor(hex: 0xC6DDCF) }
    class var middleGreen: UIColor { UIColor(hex: 0x38845F) }
    class var darkGreen: UIColor { UIColor(hex: 0x105240) }
    class var lGray: UIColor { UIColor(hex: 0xD1D1D1) }
    class var barGreen: UIColor { UIColor(hex: 0x71F171) }
    class var barYellow: UIColor { UIColor(hex: 0xFEE968) }
    class var barRed: UIColor { UIColor(hex: 0xED6969) }
}
