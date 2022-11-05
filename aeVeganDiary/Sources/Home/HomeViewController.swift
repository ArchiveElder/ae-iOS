//
//  HomeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import FSCalendar
import EventKit
import CoreLocation
import MapKit
import Alamofire

struct Event {
    var title: String
    var location: CLLocation
}

class HomeViewController: BaseViewController {
    
    lazy var homeDataManager: HomeDataManagerDelegate = HomeDataManager()
    
    var eventList = [Event]()
    
    var store = EKEventStore()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var datePickTextField: UITextField!
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
    
    @IBOutlet weak var weekCalendarView: FSCalendar!
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var calendarMessageLabel: UILabel!
    @IBOutlet weak var calendarMessageImageView: UIImageView!
    
    @IBOutlet weak var calendarInfoView: UIView!
    @IBAction func calendarInfoButtonAction(_ sender: Any) {
        calendarInfoView.isHidden = !calendarInfoView.isHidden
    }
    
    @IBOutlet weak var arcProgressBar: ArcProgressView!
    @IBOutlet weak var recommKcal: UILabel!
    @IBOutlet weak var consumeKcal: UILabel!
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var mealCollectionView: UICollectionView!
    
    let dateFormatter = DateFormatter()
    
    var selected: Int? = 0
    
    @IBOutlet weak var calLabel: UILabel!
    
    // ProgressBar
    @IBOutlet weak var carbProgressBar: UIProgressView!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var carbPercentLabel: UILabel!
    
    @IBOutlet weak var proteinProgressBar: UIProgressView!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var proteinPercentLabel: UILabel!
    
    @IBOutlet weak var fatProgressBar: UIProgressView!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var fatPercentLabel: UILabel!
    
    @IBOutlet weak var hideView: UIView!
    
    // MARK: 서버 통신 변수 선언
    var homeResult: HomeResult?
    var records = [Records]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "기록")
        
        calendarInfoView.isHidden = true
        
        //FSCalendar Custom
        weekCalendarView.delegate = self
        weekCalendarView.dataSource = self
        weekCalendarView.scope = .week
        weekCalendarView.locale = Locale(identifier: "ko_KR")
        weekCalendarView.headerHeight = 8
        weekCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        weekCalendarView.appearance.weekdayTextColor = .darkGray
        
        hideView.isHidden = true
        
        //CollectionView
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(UINib(nibName: "TabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabCollectionViewCell")
        tabCollectionView.backgroundColor = .clear
        
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        mealCollectionView.register(UINib(nibName: "RegisterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RegisterCollectionViewCell")
        mealCollectionView.register(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCollectionViewCell")
        mealCollectionView.backgroundColor = .clear
        
        //TableView
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        
        // date
        dateFormatter.dateFormat = "yyyy.MM.dd."
        self.datePickTextField.text = dateFormatter.string(from: Date())
        self.weekCalendarView.select(Date())
        datePicker.datePickerMode = .date
        // iOS 14 and above
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd."
        //datePicker.maximumDate = Date()
        self.datePickTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone), datePicker: datePicker, dateFormatter: dateFormatter)
        
        // ProgressView
        carbProgressBar.clipsToBounds = true
        carbProgressBar.layer.cornerRadius = 4
        carbProgressBar.clipsToBounds = true
        carbProgressBar.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        carbProgressBar.subviews[1].clipsToBounds = true
        
        proteinProgressBar.clipsToBounds = true
        proteinProgressBar.layer.cornerRadius = 4
        proteinProgressBar.clipsToBounds = true
        proteinProgressBar.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        proteinProgressBar.subviews[1].clipsToBounds = true
        
        fatProgressBar.clipsToBounds = true
        fatProgressBar.layer.cornerRadius = 4
        fatProgressBar.clipsToBounds = true
        fatProgressBar.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        fatProgressBar.subviews[1].clipsToBounds = true
        
        //arcProgressBar.setProgressOne(to: 1, withAnimation: false, maxSpeed: 45.0)
        
        locationManager.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        _ = try? isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
            } else if update != nil {
                if update! {
                    self.presentUpdateAlertVC()
                }
            }
        }
        
        store.requestAccess(to: .event) { granted, error in
            //if granted { self.accessGranted() }
        }
        super.viewWillAppear(animated)
        if UserManager.shared.jwt == "" {
            changeRootViewController(LoginViewController())
        } else {
            request(dateText: datePickTextField.text!)
        }
        locationManager.requestWhenInUseAuthorization()
        
        fetchEvent()
        
        if let recognizers = self.view.gestureRecognizers {
            for recognizer in recognizers {
                self.view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    // datePicker에서 Done 누르면 실행
    @objc func tapDone() {
        let nowDate = Date()
        let time = datePicker.date.timeIntervalSinceReferenceDate - nowDate.timeIntervalSinceReferenceDate
        
        if let datePicker = self.datePickTextField.inputView as? UIDatePicker {
            // textField 업데이트
            self.datePickTextField.text = dateFormatter.string(from: datePicker.date)
            self.weekCalendarView.select(datePicker.date)
        }
        // textField에서 커서 제거
        self.datePickTextField.resignFirstResponder()
        
        fetchEvent()
        
        if time <= 0 {
            request(dateText: dateFormatter.string(from: datePicker.date))
            hideView.isHidden = true
        } else {
            presentBottomAlert(message: "미래의 날짜에서는 일정만 확인 가능해요")
            hideView.isHidden = false
        }
        
        
    }
    
}

// MARK: FSCalendar
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let nowDate = Date()
        let time = date.timeIntervalSinceReferenceDate - nowDate.timeIntervalSinceReferenceDate
        //print(time)
        datePickTextField.text = dateFormatter.string(from: date)
        datePicker.date = date
        fetchEvent()
        if time <= 0 {
            request(dateText: dateFormatter.string(from: date))
            weekCalendarView.select(datePicker.date)
            hideView.isHidden = true
        } else {
            presentBottomAlert(message: "미래의 날짜에서는 일정만 확인 가능해요")
            hideView.isHidden = false
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
         return false
    }
}

// MARK: CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 탭 collectionView
        if collectionView == tabCollectionView {
            let mealList = ["아침", "점심", "저녁"]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as! TabCollectionViewCell
            cell.mealLabel.text = mealList[indexPath.row]
            cell.kcalLabel.isHidden = true
            cell.nullView.isHidden = false
            cell.kcal.isHidden = true
            if records.count != 0 && records[indexPath.row].mcal != 0 {
                cell.kcalLabel.isHidden = false
                cell.nullView.isHidden = true
                cell.kcalLabel.text = String(records[indexPath.row].mcal)
                cell.kcal.isHidden = false
            }
            
            if selected == indexPath.row {
                cell.tabBackgroundView.backgroundColor = .white
            } else {
                cell.tabBackgroundView.backgroundColor = .lGray
            }
            
            return cell
        } else {
            // 식사 collectionView
            if records.count != 0 && records[indexPath.row].record.count != 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as! MealCollectionViewCell
                cell.records = records[indexPath.row]
                cell.addButton.addTarget(self, action: #selector(toRegister(sender:)), for: .touchUpInside)
                cell.productVC = self
                cell.mealTableView.reloadData()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterCollectionViewCell", for: indexPath) as! RegisterCollectionViewCell
                cell.registerMealButton.addTarget(self, action: #selector(toRegister(sender:)), for: .touchUpInside)
                return cell
            }
            
        }
    }
    
    // 식단 등록하기 버튼 누르면 팝업 띄움
    @objc func toRegister(sender : UIButton) {
        let vc = SelectTypeViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.rdate = datePickTextField.text ?? ""
        vc.meal = selected
        present(vc, animated: false)
    }
    
    // collectionView 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
            return CGSize(width: tabCollectionView.frame.width / 3 - 1.2, height: tabCollectionView.frame.height)
        } else {
            return CGSize(width: mealCollectionView.frame.width, height: mealCollectionView.frame.height)
        }
        
    }
    
    // 탭 collectionView의 cell들 누르면 실행되는 코드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            mealCollectionView.scrollToItem(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath, at: .right, animated: false)
            selected = indexPath.row
            collectionView.reloadData()
        }
    }
    
}

// MARK: TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        cell.titleLabel.text = eventList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RestaurantViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.location = eventList[indexPath.row].location
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: EventKit
extension HomeViewController: CLLocationManagerDelegate {
    func fetchEvent() {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        dateComponents.hour = 9
        
        let dayAgo = calendar.date(from: dateComponents)
        
        dateComponents.hour = 24 - (dateComponents.hour ?? 24) + 18
        let dayAfter = calendar.date(from: dateComponents)
        store.requestAccess(to: .event) { (granted, error) in
            self.store = EKEventStore()//<---------here's trick
            //do stuff
        }
        
        let predicate = store.predicateForEvents(withStart: dayAgo!, end: dayAfter!, calendars: nil)
        let events: [EKEvent] = store.events(matching: predicate)
        
        eventList = [Event]()
        for i in events where i.structuredLocation?.geoLocation != nil {
            let lo = i.structuredLocation!.geoLocation!
            
            //let ev = Event(title: i.title, location: lo.components(separatedBy: "\n").joined())
            let ev = Event(title: i.title, location: lo)
            self.eventList.append(ev)
        }
        
        if eventList.isEmpty {
            calendarMessageLabel.isHidden = false
            calendarMessageImageView.isHidden = false
            eventTableView.isHidden = true
        } else {
            calendarMessageLabel.isHidden = true
            calendarMessageImageView.isHidden = true
            eventTableView.isHidden = false
        }
        
        eventTableView.reloadData()
    }
    
    /*func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        default:
            print("Location Servies: Denied / Restricted")
        }
    }*/
    
}


// MARK: 서버 통신
extension HomeViewController: HomeViewDelegate {
    func request(dateText: String) {
        showIndicator()
        let input = HomeRequest(date: dateText)
        homeDataManager.getDaterecord(input, delegate: self)
    }
    
    func setProgressResult(sender: UIProgressView, data: Float){
        if data < 0.3 {
            sender.progressTintColor = .barRed
        } else if data < 0.6 {
            sender.progressTintColor = .barYellow
        } else if data < 1.3 {
            sender.progressTintColor = .barGreen
        } else if data < 1.6 {
            sender.progressTintColor = .barYellow
        } else {
            sender.progressTintColor = .barRed
        }
        
        sender.progress = data
    }
    
    func didSuccessGetDaterecord(_ result: HomeResponse) {
        dismissIndicator()
        self.homeResult = result.result!
        self.records = result.result?.records ?? []
        
        let cal = (homeResult?.recommCalory ?? 0) - (homeResult?.totalCalory ?? 0)
        recommKcal.text = "\(homeResult?.recommCalory ?? 0) kcal"
        consumeKcal.text = "\(homeResult?.totalCalory ?? 0) kcal"
        
        if cal < 0 {
            self.calLabel.text = "0 kcal"
        } else {
            self.calLabel.text = "\(String(cal)) kcal"
        }
        
        self.carbLabel.text = "\(homeResult?.totalCarb ?? 0) / \(homeResult?.recommCarb ?? 0)"
        self.proteinLabel.text = "\(homeResult?.totalPro ?? 0) / \(homeResult?.recommPro ?? 0)"
        self.fatLabel.text = "\(homeResult?.totalFat ?? 0) / \(homeResult?.recommFat ?? 0)"
        
        self.records.sort(by: { $0.meal < $1.meal })
        
        self.tabCollectionView.reloadData()
        self.mealCollectionView.reloadData()
        let firstIndex = records.firstIndex(where: { $0.mcal == 0 }) ?? 0
        selected = firstIndex
        tabCollectionView.scrollToItem(at: IndexPath(item: firstIndex, section: 0), at: .left, animated: false)
        mealCollectionView.scrollToItem(at: IndexPath(item: firstIndex, section: 0), at: .left, animated: false)
        
        setProgressResult(sender: carbProgressBar, data: Float(homeResult?.totalCarb ?? 0) / Float(homeResult?.recommCarb ?? 0))
        setProgressResult(sender: proteinProgressBar, data: Float(homeResult?.totalPro ?? 0) / Float(homeResult?.recommPro ?? 0))
        setProgressResult(sender: fatProgressBar, data: Float(homeResult?.totalFat ?? 0) / Float(homeResult?.recommFat ?? 0))
        carbPercentLabel.text = "\(Int(Float(homeResult?.totalCarb ?? 0) / Float(homeResult?.recommCarb ?? 0) * 100))%"
        proteinPercentLabel.text = "\(Int(Float(homeResult?.totalPro ?? 0) / Float(homeResult?.recommPro ?? 0) * 100))%"
        fatPercentLabel.text = "\(Int(Float(homeResult?.totalFat ?? 0) / Float(homeResult?.recommFat ?? 0) * 100))%"
        
        arcProgressBar.setProgressOne(to: Double(homeResult?.totalCalory ?? 0) / Double(homeResult?.recommCalory ?? 0), withAnimation: false, maxSpeed: 45)
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
