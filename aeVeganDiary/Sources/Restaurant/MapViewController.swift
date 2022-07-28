//
//  MapViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/25.
//

import UIKit
import CoreLocation
import NMapsMap

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var location = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showBottomSheet(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            //print(locationManager.location?.coordinate)
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0)
            marker.mapView = mapView
        } else {
            print("위치 서비스 Off 상태")
        }
        
    }
    
    @objc private func showBottomSheet(_ tapRecognizer: UITapGestureRecognizer) {
        let vc = BottomViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
}


