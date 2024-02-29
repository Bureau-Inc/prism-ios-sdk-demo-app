//
//  SideMenuViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 22/09/22.
//

import UIKit
import Auth0

class SideMenuViewController: BaseViewController {

    @IBOutlet weak var userDP: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLbl.text = getUserData?.value(forKey: "userName") as? String
    }
    
    @IBAction func closeAct(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func logoutAct(_ sender: Any) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Logout", comment: ""), message: NSLocalizedString("Are you sure to logout?", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            Auth0.webAuth().clearSession { result in
                switch result {
                case .success:
                    print("Logged out")
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            let rootNC = UINavigationController(rootViewController: vc)
            rootNC.viewControllers = [vc]
            rootNC.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.windows.first?.rootViewController = rootNC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
