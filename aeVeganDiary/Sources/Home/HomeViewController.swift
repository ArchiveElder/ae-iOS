//
//  HomeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import FSCalendar

class HomeViewController: BaseViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var weekCalendarView: FSCalendar!
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "기록")
        
        //FSCalendar Custom
        weekCalendarView.delegate = self
        weekCalendarView.dataSource = self
        weekCalendarView.scope = .week
        weekCalendarView.locale = Locale(identifier: "ko_KR")
        weekCalendarView.headerHeight = 3
        weekCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        weekCalendarView.appearance.weekdayTextColor = .darkGray
        
        //CollectionView
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(UINib(nibName: "tabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tabCollectionViewCell")
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mealList = ["아침", "점심", "저녁"]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCollectionViewCell", for: indexPath) as! tabCollectionViewCell
        cell.mealLabel.text = mealList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tabCollectionView.frame.width / 3, height: tabCollectionView.frame.height)
    }
    
}
