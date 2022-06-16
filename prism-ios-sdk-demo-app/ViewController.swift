//
//  ViewController.swift
//  prism-ios-native-sdk-demo
//
//  Created by Apple on 01/06/22.
//

import UIKit
import prism_ios_native_sdk

class ViewController: UIViewController {
    
    var entryPoint:PrismEntryPoint?
    
    @IBOutlet weak var clientIdTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var digiLockerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //b66130a4-2659-48d2-a3d9-07496d7831a3
    }
    
    @IBAction func initSDKAct(_ sender: Any) {
        if(clientIdTF.text != "" || userNameTF.text != ""){
            //b66130a4-2659-48d2-a3d9-07496d7831a3
//            entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: "test_user_1", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .stage,refVC: self)

//            entryPoint?.addConfig(config: [.digilockerFlow, .myAadhaarUidaiFlow, .residentUidaiAadhaarFlow])
            
            self.view.endEditing(true)
            self.digiLockerBtn.isHidden = false
        }else{
            Toast.show(message: "Please Enter the valid ClientID & Username", controller: self)
        }
    }
    
    @IBAction func startKYCDigiLockerAct(_ sender: Any) {
        entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: userNameTF.text ?? "", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .stage,refVC: self)
        entryPoint?.prismEntryDelegate = self
        entryPoint?.addConfig(config: [.digilockerFlow, .myAadhaarUidaiFlow, .residentUidaiAadhaarFlow])
        entryPoint?.beginKYCFLow()
        
    }
    
}

extension ViewController:PrismEntryPointDelegate{
    func onKYCFinished(data: [String : Any]?) {
        if(data?["status"] as? Bool ?? false){
            Toast.show(message: "Authentication Successfully Done!", controller: self)
        }else{
            if let errorMsg = (data?["errorCode"] as? String ){
                Toast.show(message: "\(errorMsg) Access", controller: self)
                return
            }
            Toast.show(message: "KYC not verified, please try again later", controller: self)
        }
    }
}

public class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
