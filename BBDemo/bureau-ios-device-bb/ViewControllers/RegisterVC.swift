//
//  RegisterVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userIDInnerView: UIView!
    @IBOutlet weak var pwdInnerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDInnerView.layer.borderColor = UIColor.systemGray5.cgColor
        pwdInnerView.layer.borderColor = UIColor.systemGray5.cgColor

    }
    
    @IBAction func submitAct(_ sender: UIButton) {
        if sender.currentTitle == "Next"{
            passwordView.isHidden = false
            sender.setTitle("Create User ID", for: .normal)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
