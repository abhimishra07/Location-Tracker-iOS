//
//  ViewController.swift
//  Location Manager
//
//  Created by Anu on 15/09/21.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var intialValue: CLLocation?
    var finalValue: CLLocation?
    var stopButtonClicked = false
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var stopButton: UIButton!
    
    @IBAction func stopUdatinglocation(_ sender: Any) {
        stopButtonClicked = true
        locationManager.startUpdatingLocation()
    }
    
    private func handleStopButtonAction() {
        guard let initalLati = intialValue?.coordinate.latitude, let initialLong = intialValue?.coordinate.longitude, let finalLati = finalValue?.coordinate.latitude,let finalLongi = finalValue?.coordinate.longitude else {
            print("Location not found")
            return
        }
        let sourceLocation = CLLocationCoordinate2D(latitude: initalLati, longitude: initialLong)
        let destinationLocation = CLLocationCoordinate2D(latitude:finalLati, longitude: finalLongi)
            
        createPath(sourceLocation: sourceLocation, destinationLocation: destinationLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !stopButtonClicked {
            intialValue = locations.last
            let center = CLLocationCoordinate2D(latitude: intialValue!.coordinate.latitude, longitude: intialValue!.coordinate.longitude)
            let region = MKCoordinateRegion(center: intialValue!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
            self.mapView.setRegion(region, animated: true)
            print("for the 1st time: \(intialValue?.coordinate.latitude)")
        } else {
            finalValue = locations.last
            print("after click stop - \(finalValue)")
            handleStopButtonAction()
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    private func createPath(sourceLocation : CLLocationCoordinate2D, destinationLocation : CLLocationCoordinate2D) {
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        
        
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("ERROR FOUND : \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let rendere = MKPolylineRenderer(overlay: overlay)
           rendere.lineWidth = 5
           rendere.strokeColor = .systemBlue
           
           return rendere
       }
    
    
}

