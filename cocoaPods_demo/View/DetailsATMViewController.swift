//
//  DetailsATMViewController.swift
//  cocoaPods_demo
//
//  Created by Gianni on 18/5/18.
//  Copyright © 2018 Gianni. All rights reserved.
//

import UIKit

class DetailsATMViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openHoursLabel: UILabel!
    @IBOutlet weak var hasMoneyLabel: UILabel!
    @IBOutlet weak var acceptsDepositsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var address = ""
    var openHours = ""
    var hasMoney = ""
    var acceptsDeposits = ""
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = address
        openHoursLabel.text = openHours
        
    }


}
