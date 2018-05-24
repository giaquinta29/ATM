//
//  DetailsATMViewController.swift
//  cocoaPods_demo
//
//  Created by Gianni on 18/5/18.
//  Copyright © 2018 Gianni. All rights reserved.
//

import UIKit
import Alamofire

class DetailsATMViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openHoursLabel: UILabel!
    @IBOutlet weak var hasMoneyLabel: UILabel!
    @IBOutlet weak var acceptsDepositsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageNetworkView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    var address = ""
    var openHours = ""
    var hasMoney = ""
    var acceptsDeposits = ""
    var status = ""
    var imageStr = ""
    var imageNetworkStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 15
        imageNetworkView.image = UIImage(named: imageNetworkStr)
        addressLabel.text = address
        openHoursLabel.text = openHours
        let remoteImageURL = URL(string: imageStr)!
        // Use Alamofire to download the image
        request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                // Show the downloaded image:
                if let data = response.data {
                   
                    self.imageView.image = UIImage(data: data)
                    
                    
                }
            }
        }
       
       
    }


}
