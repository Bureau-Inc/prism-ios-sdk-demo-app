//
//  ViewController.swift
//  prism-ios-native-sdk-demo
//
//  Created by Apple on 01/06/22.
//

import UIKit
import prism_ios_native_sdk

class ViewController: BaseViewController {
    
    var entryPoint:PrismEntryPoint?
    
    @IBOutlet weak var crentialView: UIView!
    @IBOutlet weak var clientIdTF: UITextField!
    @IBOutlet weak var userIDView: UIView!
    @IBOutlet weak var userNameTF: UITextField!
    
    var clientKey:String?
    var isSelectedType:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        clientIdTF.text = clientKey
        userNameTF.text = getUserData?.value(forKey: "userID") as? String
        crentialView.layer.borderColor = UIColor.systemGray5.cgColor
        userIDView.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startKYCOldAadhaarAct(_ sender: Any) {
        isSelectedType = 1
        entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: userNameTF.text ?? "", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .stage,refVC: self)
        entryPoint?.prismEntryDelegate = self
        entryPoint?.addConfig(config: [.residentUidaiAadhaarFlow, .digilockerFlow, .myAadhaarUidaiFlow])
        entryPoint?.beginKYCFLow()
    }
    
    @IBAction func startKYCNewAadhaarAct(_ sender: Any) {
        isSelectedType = 2
        entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: userNameTF.text ?? "", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .stage,refVC: self)
        entryPoint?.prismEntryDelegate = self
        entryPoint?.addConfig(config: [.myAadhaarUidaiFlow, .digilockerFlow, .residentUidaiAadhaarFlow])
        entryPoint?.beginKYCFLow()
    }
    
    @IBAction func startKYCDigiLockerAct(_ sender: Any) {
        isSelectedType = 3
        entryPoint = PrismEntryPoint.init(merchantId: self.clientIdTF.text ?? "", userId: userNameTF.text ?? "", successRedirectURL: "https://successi23.net/", failureRedirectURL: "https://faili23.net/", runOnProduction: .production,refVC: self)
        entryPoint?.prismEntryDelegate = self
        entryPoint?.addConfig(config: [.digilockerFlow, .residentUidaiAadhaarFlow, .myAadhaarUidaiFlow])
        entryPoint?.beginKYCFLow()
    }
    
    @IBAction func copyClientIDAct(_ sender: Any) {
        UIPasteboard.general.string = clientIdTF.text
    }
    
    @IBAction func copyUserIDAct(_ sender: Any) {
        UIPasteboard.general.string = userNameTF.text
    }
}

extension ViewController:PrismEntryPointDelegate{
    func onKYCFinished(data: [String : Any]?) {
        if(data?["status"] as? Bool ?? false){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(VC, animated: false)
        }else{
            if let errorMsg = (data?["error"] as? NSDictionary){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "FailureViewController") as! FailureViewController
                self.navigationController?.pushViewController(VC, animated: false)
                self.view.makeToast("\((errorMsg.value(forKey: "message") as? String ?? ""))")
                //Toast.show(message: , controller: self)
                return
            }
            self.view.makeToast("KYC not verified, please try again later")
            //Toast.show(message: "KYC not verified, please try again later", controller: self)
        }
    }
}



extension ViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == clientIdTF){
            return false
        }
        return true
    }
}
