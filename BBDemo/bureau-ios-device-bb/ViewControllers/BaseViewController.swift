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
    
    var appdelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdelegate = UIApplication.shared.delegate as? AppDelegate
        
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
