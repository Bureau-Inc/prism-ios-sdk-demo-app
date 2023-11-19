//
//  MainViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 22/09/22.
//

import UIKit
import SideMenu

class MainViewController: BaseViewController {
    
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    var accessToken:String!
    var arrCrentials = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        accessToken = getUserData?.value(forKey: "accessToken") as? String
        getCredentials()
    }
    
    @IBAction func menuAct(_ sender: Any) {
        let menu = SideMenuNavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController)
        menu.leftSide = true
        menu.setNavigationBarHidden(true, animated: true)
        menu.presentationStyle = .menuSlideInCustom
        menu.menuWidth = view.frame.width * 0.70
        menu.statusBarEndAlpha = 0
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func kycAadhaarAct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        VC.clientKey = arrCrentials.first?.value(forKey: "credentialId") as? String
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func deviceIntelligentAct(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "DeviceFingerPrintVC") as! DeviceFingerPrintVC
        //VC.clientKey = arrCrentials.first?.value(forKey: "credentialId") as? String
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func livenessCheckAct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "LivenessPageVC") as! LivenessPageVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    func getCredentials(){
        spinnerView.startAnimating()
        var request = URLRequest(url: URL(string: "https://api.overwatch.stg.bureau.id/v1/auth/list")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Bearer \(accessToken ?? "")")
        request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                self.arrCrentials = try JSONSerialization.jsonObject(with: data!) as? [NSDictionary] ?? []
                print(self.arrCrentials)
            } catch {
                print("error")
            }
            DispatchQueue.main.sync {
                self.spinnerView.stopAnimating()
            }
        })
        
        task.resume()
    }

}

extension SideMenuPresentationStyle {
    static var menuSlideInCustom: SideMenuPresentationStyle {
        let item = SideMenuPresentationStyle.init()
        item.menuOnTop = true
        item.menuTranslateFactor = -1
        item.onTopShadowColor = UIColor(red: 0.024, green: 0.075, blue: 0.176, alpha: 1)
        item.onTopShadowOpacity = 0.6
        item.backgroundColor = .black
        item.presentingEndAlpha = 0.4
        return item
    }
}
