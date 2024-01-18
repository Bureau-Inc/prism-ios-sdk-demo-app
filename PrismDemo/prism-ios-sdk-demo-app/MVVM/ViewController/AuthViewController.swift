//
//  AuthViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 24/08/22.
//

import UIKit
import Auth0
import JWTDecode

class AuthViewController: BaseViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var authBtn: UIButton!
    var accessToken:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func authAct(_ sender: Any) {
        self.spinner.startAnimating()
        Auth0.webAuth().audience("https://api.overwatch.stg.bureau.id").start { result in
            switch result {
            case .success(let credentials):
                print("idToken-->",credentials)
                self.accessToken = credentials.accessToken
                guard let jwt = try? decode(jwt: credentials.idToken),
                      let name = jwt["name"].string,
                      let picture = jwt["picture"].string,
                        let org_id = jwt["org_id"].string else { return }
                print("Name: \(name)")
                print("Picture URL: \(picture)")
                print("org_id: \(org_id)")
                print(jwt)
                let userDic = ["accessToken" : self.accessToken, "userID": jwt["sub"].string, "userName" : name, "picture" : picture, "org_id" : org_id]
                try? UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: userDic,requiringSecureCoding: true), forKey: "USERDATA")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.navigationController?.pushViewController(VC, animated: true)
            case .failure(let error):
                self.spinner.stopAnimating()
                print("Failed with: \(error)")
                //Toast.show(message: error.debugDescription, controller: self)
                self.view.makeToast(error.debugDescription)
            }
        }
    }
    
    @IBAction func logoutAct(_ sender: Any) {
        Auth0.webAuth().clearSession { result in
            switch result {
            case .success:
                print("Logged out")
            case .failure(let error):
                print("Failed with: \(error)")
            }
        }
    }
}
