//
//  AuthViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 24/08/22.
//

import UIKit
import Auth0
import JWTDecode

class AuthViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    var accessToken:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 6
    }
    
    @IBAction func authAct(_ sender: Any) {
        self.spinner.startAnimating()
        Auth0.webAuth().audience("https://api.overwatch.bureau.id").start { result in
            switch result {
            case .success(let credentials):
                print("Obtained credentials: \(credentials)")
                print("accessToken-->",credentials.accessToken)
                Toast.show(message: "Success!", controller: self)
                print("idToken-->",credentials.idToken)
                self.accessToken = credentials.accessToken
                self.getCredentials()
                guard let jwt = try? decode(jwt: credentials.idToken),
                      let name = jwt["name"].string,
                      let picture = jwt["picture"].string else { return }
                print("Name: \(name)")
                print("Picture URL: \(picture)")
            case .failure(let error):
                self.spinner.stopAnimating()
                print("Failed with: \(error)")
                Toast.show(message: error.debugDescription, controller: self)
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
    
    func getCredentials(){
        var request = URLRequest(url: URL(string: "https://api.overwatch.bureau.id/v1/auth/list")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Bearer \(accessToken ?? "")")
        request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as? [NSDictionary]
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    VC.modalPresentationStyle = .fullScreen
                    VC.clientKey = json?.first?.value(forKey: "credentialId") as? String
                    self.present(VC, animated: false, completion: nil)
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
}
