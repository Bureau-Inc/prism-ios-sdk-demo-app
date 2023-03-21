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
    @IBOutlet weak var IPLocationView: UIView!
    @IBOutlet weak var IPSecurityView: UIView!
    @IBOutlet weak var otheInfoView: UIView!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var latLbl: UILabel!
    @IBOutlet weak var longLbl: UILabel!
    @IBOutlet weak var crawlerLbl: UILabel!
    @IBOutlet weak var proxyLbl: UILabel!
    @IBOutlet weak var torLbl: UILabel!
    @IBOutlet weak var debuggableLbl: UILabel!
    @IBOutlet weak var debugerLbl: UILabel!
    @IBOutlet weak var finerprintIDLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        sessionID = "DemoAppSessionId-Hari_test-new"
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
        cityNameLbl.text = dic.value(forKeyPath: "IPLocation.city") as? String
        countryNameLbl.text = dic.value(forKeyPath: "IPLocation.country") as? String
        latLbl.text = String(dic.value(forKeyPath: "IPLocation.latitude") as? Double ?? 0.0)
        longLbl.text = String(dic.value(forKeyPath: "IPLocation.longitude") as? Double ?? 0.0)
        crawlerLbl.text = (dic.value(forKeyPath: "IPSecurity.is_crawler") as? Bool)?.description.capitalized
        proxyLbl.text = (dic.value(forKeyPath: "IPSecurity.is_proxy") as? Bool)?.description.capitalized
        torLbl.text = (dic.value(forKeyPath: "IPSecurity.is_tor") as? Bool)?.description.capitalized
        debuggableLbl.text = (dic.value(forKeyPath: "debuggable") as? Bool)?.description.capitalized
        debugerLbl.text = (dic.value(forKeyPath: "remoteDesktop") as? Bool)?.description.capitalized
        finerprintIDLbl.text = (dic.value(forKeyPath: "fingerprint") as? String)
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DeviceFingerPrintVC : PrismFingerPrintDelegate{
    func onFinished(data: [String : Any]?) {
        print(data ?? "")
        let statusCode = data?["statusCode"] as? Int
        if(statusCode == 200 || statusCode == 409){
            loadSessionData(sessionID: self.sessionID ?? "")
        }else{
            self.spinner.stopAnimating()
            DispatchQueue.main.async {
                let apiResponse = data?["apiResponse"] as? NSDictionary
                self.view.makeToast(apiResponse?.value(forKeyPath: "error.message") as? String ?? "")
            }
        }
        
    }
}



