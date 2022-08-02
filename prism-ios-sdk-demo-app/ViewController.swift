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
    @IBOutlet weak var oldAadhaarBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func initSDKAct(_ sender: Any) {
        if(clientIdTF.text?.trimmingCharacters(in: .whitespaces) == ""){
            Toast.show(message: "Please enter the valid client key", controller: self)
        }else if(userNameTF.text?.trimmingCharacters(in: .whitespaces) == ""){
            Toast.show(message: "Please enter a valid userId", controller: self)
        }else{
            self.view.endEditing(true)
            self.digiLockerBtn.isHidden = false
            self.oldAadhaarBtn.isHidden = false
            Toast.show(message: "Sdk initialised successfully", controller: self)
        }
    }
    
    @IBAction func startKYCOldAadhaarAct(_ sender: Any) {
        entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: userNameTF.text ?? "", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .stage,refVC: self)
        entryPoint?.prismEntryDelegate = self
        entryPoint?.addConfig(config: [.residentUidaiAadhaarFlow, .digilockerFlow, .myAadhaarUidaiFlow])
        entryPoint?.beginKYCFLow()
    }
    
    @IBAction func startKYCNewAadhaarAct(_ sender: Any) {
        entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: userNameTF.text ?? "", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .stage,refVC: self)
        entryPoint?.prismEntryDelegate = self
        entryPoint?.addConfig(config: [.myAadhaarUidaiFlow, .residentUidaiAadhaarFlow, .digilockerFlow])
        entryPoint?.beginKYCFLow()
    }
    
    @IBAction func startKYCDigiLockerAct(_ sender: Any) {
        entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: userNameTF.text ?? "", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .stage,refVC: self)
        entryPoint?.prismEntryDelegate = self
        entryPoint?.addConfig(config: [.digilockerFlow, .residentUidaiAadhaarFlow, .myAadhaarUidaiFlow])
        entryPoint?.beginKYCFLow()
    }
    
}

extension ViewController:PrismEntryPointDelegate{
    func onKYCFinished(data: [String : Any]?) {
        if(data?["status"] as? Bool ?? false){
            Toast.show(message: "Authentication successfully done!", controller: self)
        }else{
            if let errorMsg = (data?["error"] as? NSDictionary){
                Toast.show(message: "\((errorMsg.value(forKey: "message") as? String ?? ""))", controller: self)
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
