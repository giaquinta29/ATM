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
    @IBOutlet weak var waitConnectIndicator: UIActivityIndicatorView!
    
    
    // set initial location in Montevideo
    let initialLocation = CLLocation(latitude: -34.8833, longitude: -56.1667)
    let locManager = CLLocationManager()
    let url = "http://ucu-atm.herokuapp.com/api/atm"
    let regionRadius: CLLocationDistance = 10000
    var saveAnnotation: [String : ATM] = [:]
    var hasMoney = ""
    var acceptsDeposits = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        centerMapOnLocation(location: initialLocation)
        waitConnectIndicator.startAnimating()
        
        request(url).responseJSON{ response in
            
            self.waitConnectIndicator.stopAnimating()
            
            
            if let listAtmsJSON = response.result.value {
                
                if let listAtms:[ATM] = Mapper<ATM>().mapArray(JSONArray: listAtmsJSON as! [[String : Any]]){
                    
                    
                    
                    for atm in listAtms {
                        let annotation = MKPointAnnotation()
                        let latitude = atm.coordinate?.lat
                        let longitude = atm.coordinate?.long
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                        annotation.title = atm.address
                        
                        if (atm.has_money)!{
                            self.hasMoney = "Has money"
                        }else{
                            self.hasMoney = "No money"
                        }
                            
                        if (atm.accepts_deposits)!{
                            self.acceptsDeposits = "Deposits"
                        }else{
                            self.acceptsDeposits = "No deposits"
                        }
                        annotation.subtitle = "\(self.hasMoney) | \(self.acceptsDeposits)"
                        self.saveAnnotation[atm.address!] = atm
                        self.map.addAnnotation(annotation)
                        
                    }
                }
            }else{
                self.viewAlert()
            }
            
        }
       
        map.delegate = self
    }
    
    func viewAlert(){
        let alertController = UIAlertController(title: "Error Connection", message: "The app don't have internet", preferredStyle: UIAlertControllerStyle.alert)
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
            UIAlertAction in self.viewDidLoad()
        }
        alertController.addAction(retryAction)
        self.present(alertController, animated:true)
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
        let atmValues = saveAnnotation[annotation.title!!]
        let color = colorPin(status: atmValues!.status!)
        pin.pinTintColor = color
        
        //button and image
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailAtm = storyboard.instantiateViewController(withIdentifier: "details") as! DetailsATMViewController
            
            let atmValues = saveAnnotation[view.annotation!.title!!]
            detailAtm.address = atmValues!.address!
            detailAtm.hasMoney = hasMoney
            detailAtm.openHours = atmValues!.open_hours!
            detailAtm.acceptsDeposits = acceptsDeposits
            detailAtm.imageStr = atmValues!.image_url!
            detailAtm.imageNetworkStr = atmValues!.network!.lowercased()
            self.navigationController?.pushViewController(detailAtm, animated: true)
 
            
        }
    }
    
    
    
 
    
}

