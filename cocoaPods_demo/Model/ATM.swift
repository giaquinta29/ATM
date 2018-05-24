//
//  ATM.swift
//  cocoaPods_demo
//
//  Created by Gianni on 17/5/18.
//  Copyright © 2018 Gianni. All rights reserved.
//

import Foundation
import MapKit
import ObjectMapper

class ATM: Mappable {
    var id: Int?
    var address: String?
    var network: String?
    var coordinate: Location?
    var status: String?
    var has_money: Bool?
    var accepts_deposits: Bool?
    var image_url: String?
    var open_hours: String?
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id            <- map["id"]
        address          <- map["address"]
        network      <- map["network"]
        status         <- map["status"]
        has_money         <- map["has_money"]
        accepts_deposits       <- map["accepts_deposits"]
        image_url        <- map["image_url"]
        open_hours        <- map["open_hours"]
        coordinate         <- map["location"]
    }
    
    
}

class Location:Mappable
{
    var lat: Double?
    var long:Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        lat         <- map["lat"]
        long          <- map["lon"]
    }
}
