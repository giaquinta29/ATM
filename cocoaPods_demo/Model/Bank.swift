//
//  ATM.swift
//  cocoaPods_demo
//
//  Created by Gianni on 17/5/18.
//  Copyright © 2018 Gianni. All rights reserved.
//

import Foundation
import MapKit

class ATM: NSObject,MKAnnotation {
    
    
    
    let id: Int
    let address: String
    let network: String
    let coordinate: CLLocationCoordinate2D
    let status: String
    let has_money: Bool
    let accepts_deposits: Bool
    let image_url: String
    let open_hours: String
    
    init(id: Int, coordinate: CLLocationCoordinate2D, address: String, network: String, status: String,has_money: Bool, accepts_deposits: Bool, image_url: String, open_hours:String) {
        
        self.id = id
        self.coordinate = coordinate
        self.address = address
        self.network = network
        self.status = status
        self.has_money = has_money
        self.accepts_deposits = accepts_deposits
        self.image_url = image_url
        self.open_hours = open_hours
        
        super.init()
    }
    
    
    

}
