//
//  PINViewController.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit

class PINViewController: UIViewController {

    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var pinView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinView.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    @IBAction func nextAct(_ sender: Any) {
        if pinTF.text == "000000"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "GetStartVC") as! GetStartVC
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            print("Incorrect PIN")
        }
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
