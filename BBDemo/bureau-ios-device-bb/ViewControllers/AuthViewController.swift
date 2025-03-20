//
//  AuthViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 24/08/22.
//

import UIKit
//import Auth0
import JWTDecode

class AuthViewController: BaseViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var accessToken:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.text = "login@admin.id"
        self.password.text = "Admin@1234"
    }
    
    @IBAction func authAct(_ sender: Any) {
        if let username = self.username.text, let password = self.password.text, !username.isEmpty, !password.isEmpty  {
            self.spinner.startAnimating()
            self.login(userName: username, password: password) { isSuccess in
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
                if isSuccess {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                }
            }
        }
//        Auth0.webAuth().audience("https://api.overwatch.bureau.id").start { result in
//            switch result {
//            case .success(let credentials):
//                print("idToken-->",credentials)
//                self.accessToken = credentials.accessToken
//                guard let jwt = try? decode(jwt: credentials.idToken),
//                      let name = jwt["name"].string,
//                      let picture = jwt["picture"].string else { return }
//                print("Name: \(name)")
//                print("Picture URL: \(picture)")
//                print("org_id: \("org_id")")
//                let userDic = ["accessToken" : self.accessToken, "userID": jwt["sub"].string, "userName" : name, "picture" : picture, "org_id" : "org_id"]
//                try? UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: userDic,requiringSecureCoding: true), forKey: "USERDATA")
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let VC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//                self.navigationController?.pushViewController(VC, animated: true)
//            case .failure(let error):
//                self.spinner.stopAnimating()
//                print("Failed with: \(error)")
//                //Toast.show(message: error.debugDescription, controller: self)
//            }
//        }
    }
    
    private func login(userName: String, password: String, completionBlock: @escaping ((Bool) -> Void)) {
        let urlStr = "https://t5bppcavpsfq25y452xwgpmmyu0rctjf.lambda-url.ap-south-1.on.aws/"
        let dict = ["userName": userName, "password": password]
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                completionBlock(false)
                return
            }
            request.httpBody = httpBody

            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                guard let _ = data, error == nil else {
                    completionBlock(false)
                    return
                }
                if let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 {
                    completionBlock(true)
                }
            }.resume()
        }
    }
    
    @IBAction func logoutAct(_ sender: Any) {
//        Auth0.webAuth().clearSession { result in
//            switch result {
//            case .success:
//                print("Logged out")
//            case .failure(let error):
//                print("Failed with: \(error)")
//            }
//        }
    }
}
