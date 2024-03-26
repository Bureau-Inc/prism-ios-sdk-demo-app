//
//  SigninVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit
import bureau_id_fraud_sdk

class SigninVC: BaseViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userIDInnerView: UIView!
    @IBOutlet weak var pwdInnerView: UIView!

    var isBBEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isBBEnable{
            BureauAPI.shared.startSubSession(NSUUID().uuidString)
        }
        userIDInnerView.layer.borderColor = UIColor.systemGray5.cgColor
        pwdInnerView.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    @IBAction func signinAct(_ sender: Any) {
        if userIdTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            self.showAlert(title: "Error", message: "Invalid Email")
        }else if passwordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            self.showAlert(title: "Error", message: "Invalid Password")
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
            VC.userName = userIdTF.text
            VC.password = passwordTF.text
            VC.isBBEnable = isBBEnable
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController{
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
