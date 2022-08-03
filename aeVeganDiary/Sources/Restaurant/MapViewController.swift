//
//  MapViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/25.
//

import UIKit
//import NMapsMap
import GoogleMaps

class MapViewController: UIViewController {
    
    var location = ""
    //@IBOutlet weak var mapView: NMFMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*mapView.allowsRotating = false
        mapView.minZoomLevel = 5.0
        mapView.maxZoomLevel = 18.0
        mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
        
        mapView.logoAlign = .leftTop*/
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(Constant.HEADERS)
        showIndicator()
        Geocoding().getCoordinates(location, viewController: self)
    }
    
}


// MARK: 서버 통신
extension MapViewController {
    func getCoor(latitude: String, longtitude: String) {
        
        if let latitude = Double(latitude), let longtitude = Double(longtitude) {
            /*let pos = NMGLatLng(lat: latitude, lng: longtitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: pos)
            cameraUpdate.animation = .none
            mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.iconImage = NMF_MARKER_IMAGE_BLUE
            marker.position = pos
            marker.width = 25
            marker.height = 35
            marker.mapView = mapView*/
        } else {
            print("안돼")
        }
        
        MapDataManager().requestRestaurant(viewController: self)
    }
    
    func getResList(result: MapResponse) {
        dismissIndicator()
        for i in result.data {
            let latitude = i.la
            let longtitude = i.lo
            /*let marker = NMFMarker()
            marker.position = NMGLatLng(lat: Double(latitude)!, lng: Double(longtitude)!)
            marker.width = 25
            marker.height = 35
            marker.mapView = mapView
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                
                /*let vc = BottomViewController()
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)*/
                
                //self.showBottomSheet()
                //let navigationController = UINavigationController(rootViewController: BottomViewController())
                //self.present(BottomViewController(), animated: true, completion: nil)
                return true
            }*/
        }
        
    }
}
