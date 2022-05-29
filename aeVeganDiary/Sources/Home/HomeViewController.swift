//
//  HomeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import FSCalendar

class HomeViewController: BaseViewController {

    @IBOutlet weak var weekCalendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "기록")
        
        weekCalendarView.delegate = self
        weekCalendarView.dataSource = self
        weekCalendarView.scope = .week
        weekCalendarView.locale = Locale(identifier: "ko_KR")
        weekCalendarView.headerHeight = 3
        weekCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        weekCalendarView.appearance.weekdayTextColor = .darkGray
    }

}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
}
