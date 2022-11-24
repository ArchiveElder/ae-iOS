//
//  MapViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/25.
//

import UIKit
//import NMapsMap
import GoogleMaps
import GoogleMapsUtils
import EventKit
import SafariServices

class MapViewController: BaseViewController, GMSMapViewDelegate {
    
    lazy var mapDataManager: MapDataManagerDelegate = MapDataManager()
    lazy var bookmarkDataManager: BookmarkDataManagerDelegate = BookmarkDataManager()
    lazy var bookmarkDeleteDataManager: BookmarkDeleteDataManagerDelegate = BookmarkDeleteDataManager()
    
    var location: CLLocation?
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var roadAddrLabel: UILabel!
    @IBOutlet weak var lnmAddrLabel: UILabel!
    var restaurantUrl = ""
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func bookmark(_ sender: Any) {
        if markerIndex != nil {
            if bookmarkButton.isSelected == false {
                showIndicator()
                bookmarkDataManager.postBookmark(BookmarkRequest(bistroId: markerIndex!), delegate: self)
            } else {
                showIndicator()
                bookmarkDeleteDataManager.deleteBookmark(BookmarkRequest(bistroId: markerIndex!), delegate: self)
            }
        }
    }
    
    @IBAction func restaurantDetailButtonAction(_ sender: Any) {
        let url = URL(string: restaurantUrl)!
        let safariView : SFSafariViewController = SFSafariViewController(url: url)
        present(safariView, animated: true, completion: nil)
    }
    
    var restaurantList = [MapData]()
    var filteredRestaurantList = [MapData]()
    var markerList = [GMSMarker]()
    var markerIndex: Int? = nil
    
    var mainCategory = ""
    var middleCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 37.5034158, longitude: 127.0650719, zoom: 13)
        mapView.frame = .zero
        mapView.camera = camera
        mapView.delegate = self
        
        infoView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showIndicator()
        
        if location != nil {
            let latitude = location?.coordinate.latitude
            let longtitude = location?.coordinate.longitude
            let mapCenter = CLLocationCoordinate2DMake(latitude ?? 37.5666805, longtitude ?? 126.9784147)
            let marker = GMSMarker(position: mapCenter)
            marker.icon = UIImage(named: "currentpin")
            marker.map = mapView
            mapView.camera = GMSCameraPosition.camera(withLatitude: latitude ?? 37.5666805, longitude: longtitude ?? 126.9784147, zoom: 15)
        } else {
            mapView.camera = GMSCameraPosition.camera(withLatitude: 37.5666805, longitude: 126.9784147, zoom: 15)
        }
        
        mapDataManager.getMap(delegate: self)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        infoView.isHidden = false

        // Animate to the marker
        mapView.animate(toLocation: marker.position)

        // If the tap was on a marker cluster, zoom in on the cluster
        if let _ = marker.userData as? GMUCluster {
          mapView.animate(toZoom: mapView.camera.zoom + 1)
          return true
        }
        if !filteredRestaurantList.isEmpty {
            if let firstIndex = markerList.firstIndex(of: marker) {
                let info = filteredRestaurantList[firstIndex]
                markerIndex = info.bistro_id
                nameLabel.text = info.name
                categoryLabel.text = info.middleCategory
                roadAddrLabel.text = info.roadAddr
                lnmAddrLabel.text = info.lnmAddr
                restaurantUrl = info.bistroUrl ?? ""
                if info.isBookmark == 1 {
                    bookmarkButton.isSelected = true
                } else {
                    bookmarkButton.isSelected = false
                }
            } else {
                markerIndex = nil
            }
        } else {
            if let firstIndex = markerList.firstIndex(of: marker) {
                let info = restaurantList[firstIndex]
                markerIndex = info.bistro_id
                nameLabel.text = info.name
                categoryLabel.text = info.middleCategory
                roadAddrLabel.text = info.roadAddr
                lnmAddrLabel.text = info.lnmAddr
                restaurantUrl = info.bistroUrl ?? ""
                if info.isBookmark == 1 {
                    bookmarkButton.isSelected = true
                } else {
                    bookmarkButton.isSelected = false
                }
            } else {
                markerIndex = nil
            }
        }
        
        return false
    }
    
    func loadMap(mainCategory: String, middleCategory: String) {
        infoView.isHidden = true
        
        if mainCategory == "" || middleCategory == "" {
            return
        }
        
        self.mainCategory = mainCategory
        self.middleCategory = middleCategory
        
        for i in markerList {
            i.map = nil
        }
        markerList.removeAll()
        
        if middleCategory == "전체" {
            filteredRestaurantList = restaurantList
        } else {
            filteredRestaurantList = restaurantList.filter{ $0.mainCategory == mainCategory && $0.middleCategory == middleCategory }
        }
        
        print("mainCategory \(mainCategory)")
        print("middleCategory \(middleCategory)")
        print(filteredRestaurantList)
        for i in filteredRestaurantList {
            let mapCenter = CLLocationCoordinate2DMake(i.la, i.lo)
            let marker = GMSMarker(position: mapCenter)
            if i.isBookmark == 1 {
                marker.icon = UIImage(named: "locationpinbookmark")
            } else {
                marker.icon = UIImage(named: "locationpin")
            }
            
            marker.map = mapView
            markerList.append(marker)
        }
    }
}

// MARK: 서버 통신
extension MapViewController: MapViewDelegate, BookmarkViewDelegate, BookmarkDeleteViewDelegate {
    func didSuccessGetMap(_ result: MapResponse) {
        dismissIndicator()
        for i in markerList {
            i.map = nil
        }
        markerList.removeAll()
        
        let result = result.result
        if let data = result?.data {
            for i in data {
                let mapCenter = CLLocationCoordinate2DMake(i.la, i.lo)
                let marker = GMSMarker(position: mapCenter)
                if i.isBookmark == 1 {
                    marker.icon = UIImage(named: "locationpinbookmark")
                } else {
                    marker.icon = UIImage(named: "locationpin")
                }
                
                marker.map = mapView
                markerList.append(marker)
            }
            
            restaurantList = data
        }
        
        self.loadMap(mainCategory: self.mainCategory, middleCategory: self.middleCategory)
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
    
    func didSuccessPostBookmark(_ result: BookmarkResponse) {
        bookmarkButton.isSelected = true
        mapDataManager.getMap(delegate: self)
    }
    
    func didSuccessDeleteBookmark(_ result: BookmarkResponse) {
        bookmarkButton.isSelected = false
        mapDataManager.getMap(delegate: self)
    }
    
    
}
