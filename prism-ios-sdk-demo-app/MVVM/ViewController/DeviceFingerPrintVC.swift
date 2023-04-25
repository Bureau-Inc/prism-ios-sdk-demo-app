//
//  DeviceFingerPrintVC.swift
//  prism-ios-sdk-demo-app
//
//  Created by Apple on 14/11/22.
//

import UIKit
import prism_ios_fingerprint_sdk

class DeviceFingerPrintVC: UIViewController {

    var entrypoint:BureauAPI?
    var sessionID:String?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var GPSLocationView: UIView!
    @IBOutlet weak var IPLocationView: UIView!
    @IBOutlet weak var IPSecurityView: UIView!
    @IBOutlet weak var otheInfoView: UIView!
    
    @IBOutlet weak var gpsCityNameLbl: UILabel!
    @IBOutlet weak var gpsCountryNameLbl: UILabel!
    @IBOutlet weak var gpsLatLbl: UILabel!
    @IBOutlet weak var gpsLongLbl: UILabel!
    @IBOutlet weak var gpsRegionLbl: UILabel!
    
    @IBOutlet weak var IPCityNameLbl: UILabel!
    @IBOutlet weak var IPcountryNameLbl: UILabel!
    @IBOutlet weak var IPlatLbl: UILabel!
    @IBOutlet weak var IPlongLbl: UILabel!
    @IBOutlet weak var IPregionLbl: UILabel!
    @IBOutlet weak var IPaddressLbl: UILabel!
    
    @IBOutlet weak var OSLbl: UILabel!
    @IBOutlet weak var DeviceModelLbl: UILabel!
    @IBOutlet weak var crawlerLbl: UILabel!
    @IBOutlet weak var proxyLbl: UILabel!
    @IBOutlet weak var torLbl: UILabel!
    @IBOutlet weak var threatLevelLbl: UILabel!
    @IBOutlet weak var debuggableLbl: UILabel!
    @IBOutlet weak var simulatorLbl: UILabel!
    @IBOutlet weak var finerprintIDLbl: UILabel!
    @IBOutlet weak var firstSeenLbl: UILabel!
    @IBOutlet weak var mockGPSLbl: UILabel!
    @IBOutlet weak var appPackageLbl: UILabel!
    @IBOutlet weak var rootedLbl: UILabel!
    @IBOutlet weak var screenMirrorLbl: UILabel!
    @IBOutlet weak var userIDLbl: UILabel!
    
//    @IBOutlet weak var debugerLbl: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        sessionID = "DemoAppSession-ID-"+(UIDevice.current.identifierForVendor?.uuidString ?? "")
        entrypoint = BureauAPI(clientID: "1b87dd79-8504-425c-90c3-56f4cad27b0f", environment: .sandbox, sessionID: sessionID ?? "", refVC: self)
        entrypoint?.fingerprintDelegate = self
        entrypoint?.submit()
    }
    
    func loadSessionData(sessionID:String){
        guard let serviceUrl = URL(string: ("https://api.overwatch.dev.bureau.id/v1/deviceService/fingerprint/" + sessionID)) else { return }
        var request = URLRequest(url: serviceUrl)
        print(request)
        request.httpMethod = "GET"
        request.setValue("Basic OTA1MmU3MjEtZTJkMS00NDk5LWFmMTItYzk2OGI5OGRjN2M5OmI3N2IzMmM0LWFlMjEtNDAwZi1hMDhhLWU0YWU0MzJhYTNjMA==", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? NSDictionary {
                print(responseJSON)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.updateUI(responseJSON)
                }
            }
        }.resume()
    }
    
    func updateUI(_ dic:NSDictionary){
       
        if((dic.value(forKeyPath: "GPSLocation.longitude")) as? Int == 0 || (dic.value(forKeyPath: "GPSLocation.longitude")) as? Int == 0){
            GPSLocationView.isHidden = true
        }else{
            GPSLocationView.isHidden = false
        }
        gpsCityNameLbl.text = dic.value(forKeyPath: "GPSLocation.city") as? String
        gpsCountryNameLbl.text = dic.value(forKeyPath: "GPSLocation.country") as? String
        gpsLatLbl.text = String(dic.value(forKeyPath: "GPSLocation.latitude") as? Double ?? 0.0)
        gpsLongLbl.text = String(dic.value(forKeyPath: "GPSLocation.longitude") as? Double ?? 0.0)
        gpsRegionLbl.text = dic.value(forKeyPath: "GPSLocation.region") as? String
        
        IPCityNameLbl.text = dic.value(forKeyPath: "IPLocation.city") as? String
        IPcountryNameLbl.text = dic.value(forKeyPath: "IPLocation.country") as? String
        IPlatLbl.text = String(dic.value(forKeyPath: "IPLocation.latitude") as? Double ?? 0.0)
        IPlongLbl.text = String(dic.value(forKeyPath: "IPLocation.longitude") as? Double ?? 0.0)
        IPregionLbl.text = dic.value(forKeyPath: "IPLocation.region") as? String
        
        crawlerLbl.text = CheckBool(dic.value(forKeyPath: "IPSecurity.is_crawler") as? Bool)
        proxyLbl.text = CheckBool((dic.value(forKeyPath: "IPSecurity.is_proxy") as? Bool))
        torLbl.text = CheckBool(dic.value(forKeyPath: "IPSecurity.is_tor") as? Bool)
        threatLevelLbl.text = dic.value(forKeyPath: "IPSecurity.threat_level") as? String
        debuggableLbl.text = CheckBool(dic.value(forKeyPath: "debuggable") as? Bool)
        simulatorLbl.text = CheckBool(dic.value(forKeyPath: "emulator") as? Bool)
        mockGPSLbl.text = CheckBool(dic.value(forKeyPath: "mockgps") as? Bool)
        screenMirrorLbl.text = CheckBool(dic.value(forKeyPath: "remoteDesktop") as? Bool)
        finerprintIDLbl.text = (dic.value(forKeyPath: "fingerprint") as? String)
        DeviceModelLbl.text = (dic.value(forKeyPath: "model") as? String)
        appPackageLbl.text = (dic.value(forKeyPath: "package") as? String)
        rootedLbl.text = CheckBool(dic.value(forKeyPath: "jailbreak") as? Bool)
        userIDLbl.text = (dic.value(forKeyPath: "sessionId") as? String)
        OSLbl.text = (dic.value(forKeyPath: "OS") as? String)
        firstSeenLbl.text = String(dic.value(forKeyPath: "firstSeenDays") as? Int ?? 0)
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func CheckBool(_ val:Bool?) -> String{
        return val ?? false ? "Yes" : "No"
    }
}

extension DeviceFingerPrintVC : PrismFingerPrintDelegate{
    func onFinished(data: [String : Any]?) {
        let statusCode = data?["statusCode"] as? Int
        if(statusCode == 200 || statusCode == 409){
            loadSessionData(sessionID: self.sessionID ?? "")
        }else if statusCode == 401{
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                let apiResponse = data?["apiResponse"] as? NSDictionary
                self.view.makeToast(apiResponse?.value(forKeyPath: "errors.errorCode") as? String ?? "")
            }
        }else{
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                let apiResponse = data?["apiResponse"] as? NSDictionary
                self.view.makeToast(apiResponse?.value(forKeyPath: "error.message") as? String ?? "")
            }
        }
        
    }
}



