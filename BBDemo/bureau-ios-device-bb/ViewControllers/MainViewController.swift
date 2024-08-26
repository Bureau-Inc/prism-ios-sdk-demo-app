//
//  MainViewController.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 22/09/22.
//

import UIKit
import SideMenu
import CoreLocation

class MainViewController: BaseViewController {
    
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    var accessToken:String!
    var org_id:String?
    
    var locationManager = CLLocationManager()
    var location:CLLocation?
    
    var arrCrentials = [NSDictionary]()
    @IBOutlet weak var bioMatricView: UIView!
    @IBOutlet weak var diView: UIView!
    @IBOutlet weak var behaviourSwitch: UISwitch!
    @IBOutlet weak var diSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessToken = getUserData?.value(forKey: "accessToken") as? String
        org_id = getUserData?.value(forKey: "org_id") as? String

        bioMatricView.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 247/255, alpha: 1).cgColor
        diView.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 247/255, alpha: 1).cgColor
        getCredentials()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
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
    
    
    @IBAction func getStartBtn(_ sender: Any) {
        
        if behaviourSwitch.isOn{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let VC = storyboard.instantiateViewController(withIdentifier: "PINViewController") as! PINViewController
//            VC.isBBEnable = behaviourSwitch.isOn
//            self.navigationController?.pushViewController(VC, animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "GetStartVC") as! GetStartVC
            VC.isBBEnable = behaviourSwitch.isOn
            self.navigationController?.pushViewController(VC, animated: true)

        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "GetStartVC") as! GetStartVC
            self.navigationController?.pushViewController(VC, animated: true)

        }

    }
    
    func getCredentials(){
        spinnerView.startAnimating()
        var request = URLRequest(url: URL(string: "https://api.overwatch.bureau.id/v1/auth/list")!)
        request.httpMethod = "GET"
        request.addValue(org_id ?? "", forHTTPHeaderField: "X-Bureau-Auth-Org-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        print("Bearer \(accessToken ?? "")")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                self.arrCrentials = try JSONSerialization.jsonObject(with: data!) as? [NSDictionary] ?? []
                UserDefaults.standard.set(self.arrCrentials.first?.value(forKey: "credentialId") as? String, forKey: "credentialId")
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

extension MainViewController: CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
}
