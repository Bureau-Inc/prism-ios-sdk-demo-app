//
//  GetStartVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit

class GetStartVC: UIViewController {

    var isBBEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signinAct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        VC.isBBEnable = isBBEnable
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func signupAct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        VC.isBBEnable = isBBEnable
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
