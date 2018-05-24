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
import ObjectMapper

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    
    // set initial location in Montevideo
    let initialLocation = CLLocation(latitude: -34.8833, longitude: -56.1667)
    let locManager = CLLocationManager()
    let url = "http://ucu-atm.herokuapp.com/api/atm"
    let regionRadius: CLLocationDistance = 10000
    var saveAnnotation: [String : ATM] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        centerMapOnLocation(location: initialLocation)
        
        request(url).responseJSON{ response in
            
            if let listAtmsJSON = response.result.value {
                
                if let listAtms:[ATM] = Mapper<ATM>().mapArray(JSONArray: listAtmsJSON as! [[String : Any]]){
                    
                    for atm in listAtms {
                        let annotation = MKPointAnnotation()
                        let latitude = atm.coordinate?.lat
                        let longitude = atm.coordinate?.long
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                        annotation.title = atm.address
                        var hasMoney = "Not has money"
                        var acceptsDeposits = "Not deposits"
                        if (atm.has_money)!{
                            hasMoney = "Has money"
                        }
                        if (atm.has_money)!{
                            acceptsDeposits = "Deposits"
                        }
                        annotation.subtitle = "\(hasMoney) | \(acceptsDeposits)"
                        self.saveAnnotation[atm.address!] = atm
                        self.map.addAnnotation(annotation)
                        
                    }
                }
            }
            
        }
       
        map.delegate = self
    }
    
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
        var atmValues = saveAnnotation[annotation.title!!]
        let color = colorPin(status: atmValues!.status!)
        pin.pinTintColor = color
        
        //boton e imagen
        let detailsButton = UIButton(frame: CGRect(origin:CGPoint(x:0,y:0), size: CGSize(width: 90, height: 30)))
        detailsButton.setImage(UIImage(named: "\(atmValues!.network!.lowercased() )"), for: .normal)
        pin.rightCalloutAccessoryView = detailsButton
            
        return pin
        
    }
 
    func colorPin (status: String) -> UIColor{
        let color: UIColor
        if (status == "normal" || status == "normal (with tint)"){
            color = UIColor.green
        }else{
            if (status == "exploded"){
                color = UIColor.red
            }else{
                color = UIColor.black
            }
        }
        return color
    }
    
    var anotacionSeleccionada : MKPointAnnotation!

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailAtm = storyboard.instantiateViewController(withIdentifier: "details") as! DetailsATMViewController
            
            //se pasan los datos de los detalles
            let atmValues = saveAnnotation[view.annotation!.title!!]
            detailAtm.address = atmValues!.address!
            detailAtm.hasMoney = boolToString(value: atmValues!.has_money)
            detailAtm.openHours = atmValues!.open_hours!
            detailAtm.acceptsDeposits = boolToString(value: atmValues!.accepts_deposits)
            detailAtm.imageStr = atmValues!.image_url!
            detailAtm.imageNetworkStr = atmValues!.network!.lowercased()
            self.navigationController?.pushViewController(detailAtm, animated: true)
        }
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

