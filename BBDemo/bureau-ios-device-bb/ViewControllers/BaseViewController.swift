//
//  BaseViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 22/09/22.
//

import UIKit
import prism_ios_fingerprint_sdk

class BaseViewController: UIViewController {

    var getUserData:NSDictionary?
    
    var entrypoint:BureauAPI?
    var sessionID:String?
    var appdelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdelegate = UIApplication.shared.delegate as? AppDelegate

//        sessionID = "Demo-"+NSUUID().uuidString
//        entrypoint = nil
//        entrypoint = BureauAPI(clientID: "1b87dd79-8504-425c-90c3-56f4cad27b0f", environment: .sandbox, sessionID: sessionID ?? "", refVC: self, enableBehavioralBiometrics: true)
////        entrypoint?.setUserID("Bureau-user")

        if(UserDefaults.standard.value(forKey: "USERDATA") as? Data != nil){
            do {
                getUserData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(UserDefaults.standard.object(forKey: "USERDATA") as! Data) as? NSDictionary
            } catch {
                print("didn't work")
            }
        }
    }

}

extension UINavigationController {
   
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
  func backToViewController(viewController: Swift.AnyClass) {
     
    for element in viewControllers as Array {
      if element.isKind(of: viewController) {
        self.popToViewController(element, animated: true)
        break
      }
    }
  }
}
