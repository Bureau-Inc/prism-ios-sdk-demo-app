//
//  SuccessViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 22/09/22.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func PopVCAct(_ sender: Any) {
        self.navigationController?.backToViewController(viewController: MainViewController.self)
    }
    
}


class FailureViewController: UIViewController {

    var lastType:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func PopVCAct(_ sender: Any) {
        self.navigationController?.backToViewController(viewController: MainViewController.self)
    }
    
    @IBAction func tryAgainVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
//        switch lastType{
//        case 1:
//            
//        case 2:
//            
//        default:
//            self.navigationController?.popViewController(animated: false)
//        }
    }
}
