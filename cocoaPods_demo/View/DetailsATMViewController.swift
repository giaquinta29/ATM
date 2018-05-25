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
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var detailsAtmView: UIView!
    
    @IBOutlet weak var waitConnectIndicator: UIActivityIndicatorView!
    
    
    var address = ""
    var openHours = ""
    var hasMoney = ""
    var acceptsDeposits = ""
    var status = ""
    var imageStr = ""
    var imageNetworkStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        detailsAtmView.layer.cornerRadius = 10
        detailsAtmView.clipsToBounds = true
        
        
        // Show the details to ATM
        imageNetworkView.image = UIImage(named: imageNetworkStr)
        addressLabel.text = address
        openHoursLabel.text = openHours
        hasMoneyLabel.text = hasMoney
        acceptsDepositsLabel.text = acceptsDeposits
        
        waitConnectIndicator.startAnimating()
        
        //Download the image
        let remoteImageURL = URL(string: imageStr)!
        request(remoteImageURL).responseData { (response) in
            self.waitConnectIndicator.stopAnimating()
            
            if response.error == nil {
                print(response.result)
                // Show the downloaded image:
                if let data = response.data {
                    
                    //Degredete the image
                    let view = UIView(frame: self.imageView.frame)
                    let gradient = CAGradientLayer()
                    gradient.frame = view.frame
                    gradient.colors = [UIColor.clear.cgColor,UIColor.white.cgColor]
                    gradient.locations = [0.0, 1.0]
                    view.layer.insertSublayer(gradient, at: 0)
                    self.imageView.addSubview(view)
                    self.imageView.bringSubview(toFront: view)
                    self.imageView.image = UIImage(data: data)
                    
                    
                }
            }else {
                self.viewAlert()
            }
        }
       
       
    }
    
    func viewAlert(){
        let alertController = UIAlertController(title: "Error Connection", message: "The app don't have internet", preferredStyle: UIAlertControllerStyle.alert)
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.viewDidLoad()
        }
        alertController.addAction(retryAction)
        self.present(alertController, animated:true)
        
    }
    
  
    @IBAction func buttonBackView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
