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

class MapViewController: BaseViewController, GMSMapViewDelegate {
    
    var location = ""
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var roadAddrLabel: UILabel!
    @IBOutlet weak var lnmAddrLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func bookmark(_ sender: Any) {
        if markerIndex != nil {
            if bookmarkButton.isSelected == false {
                showIndicator()
                BookmarkDataManager().postBookmark(BookmarkInput(bistroId: markerIndex!), viewController: self)
            } else {
                showIndicator()
                BookmarkDeleteDataManager().deleteBookmark(BookmarkInput(bistroId: markerIndex!), viewController: self)
            }
        }
    }
    
    var restaurantList = [MapData]()
    var markerList = [GMSMarker]()
    var markerIndex: Int? = nil
    
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
        Geocoding().getCoordinates(location, viewController: self)
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
        
        if let firstIndex = markerList.firstIndex(of: marker) {
            let info = restaurantList[firstIndex]
            markerIndex = info.bistro_id
            nameLabel.text = info.name
            categoryLabel.text = info.category
            roadAddrLabel.text = info.roadAddr
            lnmAddrLabel.text = info.lnmAddr
            if info.isBookmark == 1 {
                bookmarkButton.isSelected = true
            } else {
                bookmarkButton.isSelected = false
            }
        } else {
            markerIndex = nil
        }

        return false
    }
}


// MARK: 서버 통신
extension MapViewController {
    func getCoor(latitude: String, longtitude: String) {
        
        if let latitude = Double(latitude), let longtitude = Double(longtitude) {
            let mapCenter = CLLocationCoordinate2DMake(latitude, longtitude)
            let marker = GMSMarker(position: mapCenter)
            marker.icon = UIImage(named: "currentpin")
            marker.map = mapView
            mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longtitude, zoom: 15)
        } else {
            print("coordinate error")
        }
        
        MapDataManager().requestRestaurant(viewController: self)
    }
    
    func getResList(result: MapResponse) {
        dismissIndicator()
        for i in result.data {
            let mapCenter = CLLocationCoordinate2DMake(i.la, i.lo)
            let marker = GMSMarker(position: mapCenter)
            marker.icon = UIImage(named: "locationpin")
            marker.map = mapView
            markerList.append(marker)
        }
        
        restaurantList = result.data
    }
    
    func bookmark() {
        dismissIndicator()
        bookmarkButton.isSelected = true
    }
    
    func bookmarkDelete() {
        dismissIndicator()
        bookmarkButton.isSelected = false
    }
}
