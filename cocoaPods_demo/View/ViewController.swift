//
//  ViewController.swift
//  cocoaPods_demo
//
//  Created by Gianni on 16/5/18.
//  Copyright © 2018 Gianni. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    
    // set initial location in Montevideo
    let initialLocation = CLLocation(latitude: -34.8833, longitude: -56.1667)
    let locManager = CLLocationManager()
    
    // levantar json
    let atm =  ATM(id: 1, coordinate: CLLocationCoordinate2D(latitude: -34.8914994, longitude: -56.1587459), address: "Av. 8 de Octubre 2720", network: "Banred", status: "normal",has_money: true, accepts_deposits: true, image_url: "",open_hours: "9 am to 5 pm")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        centerMapOnLocation(location: initialLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = atm.coordinate
        annotation.title = atm.address
        annotation.subtitle = "\(atm.has_money) | \(atm.accepts_deposits)"
        map.addAnnotation(annotation)
        
        

    }

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailAtm = storyboard.instantiateViewController(withIdentifier: "details") as! DetailsATMViewController
        
        //se pasan los datos de los detalles
        detailAtm.address = atm.address
        detailAtm.hasMoney = boolToString(value: atm.has_money)
        detailAtm.openHours = atm.open_hours
        detailAtm.acceptsDeposits = boolToString(value: atm.accepts_deposits)
        
        self.navigationController?.pushViewController(detailAtm, animated: true)
    }
    
    func boolToString(value: Bool?) -> String {
        if let value = value {
            return "\(value)"
        }
        else {
            return "<None>"
            
        }
    }
    
}

