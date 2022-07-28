//
//  MapViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/25.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController{
    
    var location = ""
    @IBOutlet weak var mapView: NMFMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showBottomSheet(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        mapView.allowsRotating = false
        mapView.minZoomLevel = 5.0
        mapView.maxZoomLevel = 18.0
        mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Geocoding().getCoordinates(location, viewController: self)
    }
    
    @objc private func showBottomSheet(_ tapRecognizer: UITapGestureRecognizer) {
        let vc = BottomViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
}

extension MapViewController {
    func getCoor(latitude: String, longtitude: String) {
        
        if let latitude = Double(latitude), let longtitude = Double(longtitude) {
            let pos = NMGLatLng(lat: latitude, lng: longtitude)
            print(pos)
            let cameraUpdate = NMFCameraUpdate(scrollTo: pos)
            cameraUpdate.animation = .none
            mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.position = pos
            marker.mapView = mapView
        } else {
            print("안돼")
        }
    }
}
