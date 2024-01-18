//
//  ResultVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit
import prism_ios_fingerprint_sdk
import CoreLocation

class ResultVC: UIViewController {

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var bioWarnView: UIView!
    @IBOutlet weak var bioWarinnerView: UIView!
    @IBOutlet weak var bioResultView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var bioRiskLevelView: UIView!
    @IBOutlet weak var bioRiskIco: UIImageView!
    @IBOutlet weak var bioRistTitle: UILabel!
    @IBOutlet weak var bioRiskValue: UILabel!
    @IBOutlet weak var bioRiskScore: UILabel!
    @IBOutlet weak var appFamiliScore: UILabel!
    @IBOutlet weak var dataFamiliScore: UILabel!
    @IBOutlet weak var exportUserScore: UILabel!
    @IBOutlet weak var botScore: UILabel!
    
    
    @IBOutlet weak var riskLevelView: UIView!
    @IBOutlet weak var riskIco: UIImageView!
    @IBOutlet weak var ristTitle: UILabel!
    @IBOutlet weak var riskValue: UILabel!
    
    @IBOutlet weak var mockGpsView: UIView!
    @IBOutlet weak var mockGpsIco: UIImageView!
    @IBOutlet weak var mockGpsTitle: UILabel!
    @IBOutlet weak var mockGpsValue: UILabel!
    
    @IBOutlet weak var vpnView: UIView!
    @IBOutlet weak var vpnIco: UIImageView!
    @IBOutlet weak var vpnTitle: UILabel!
    @IBOutlet weak var vpnValue: UILabel!
    
    @IBOutlet weak var tamparedView: UIView!
    @IBOutlet weak var tamparedIco: UIImageView!
    @IBOutlet weak var tamparedTitle: UILabel!
    @IBOutlet weak var tamparedValue: UILabel!
    
    @IBOutlet weak var emulatorView: UIView!
    @IBOutlet weak var emulatorIco: UIImageView!
    @IBOutlet weak var emulatorTitle: UILabel!
    @IBOutlet weak var emulatorValue: UILabel!
    
    @IBOutlet weak var clonedView: UIView!
    @IBOutlet weak var clonedIco: UIImageView!
    @IBOutlet weak var clonedTitle: UILabel!
    @IBOutlet weak var clonedValue: UILabel!
    
    @IBOutlet weak var rootedView: UIView!
    @IBOutlet weak var rootedIco: UIImageView!
    @IBOutlet weak var rootedTitle: UILabel!
    @IBOutlet weak var rootedValue: UILabel!
    
    @IBOutlet weak var debugView: UIView!
    @IBOutlet weak var debugIco: UIImageView!
    @IBOutlet weak var debugTitle: UILabel!
    @IBOutlet weak var debugValue: UILabel!
    
    @IBOutlet weak var crowlerView: UIView!
    @IBOutlet weak var crowlerIco: UIImageView!
    @IBOutlet weak var crowlerTitle: UILabel!
    @IBOutlet weak var crowlerValue: UILabel!
    
    @IBOutlet weak var proxyView: UIView!
    @IBOutlet weak var proxyIco: UIImageView!
    @IBOutlet weak var proxyTitle: UILabel!
    @IBOutlet weak var proxyValue: UILabel!
    
    @IBOutlet weak var torView: UIView!
    @IBOutlet weak var torIco: UIImageView!
    @IBOutlet weak var torTitle: UILabel!
    @IBOutlet weak var torValue: UILabel!
    
    @IBOutlet weak var rdView: UIView!
    @IBOutlet weak var rdIco: UIImageView!
    @IBOutlet weak var rdTitle: UILabel!
    @IBOutlet weak var rdValue: UILabel!
    
    @IBOutlet weak var cdView: UIView!
    @IBOutlet weak var cdIco: UIImageView!
    @IBOutlet weak var cdTitle: UILabel!
    @IBOutlet weak var cdValue: UILabel!
    
    
    @IBOutlet weak var osLbl: UILabel!
    @IBOutlet weak var ipaddressLbl: UILabel!
    @IBOutlet weak var gpsLocLbl: UILabel!
    @IBOutlet weak var iplocationLbl: UILabel!
    @IBOutlet weak var fingerprintIDLbl: UILabel!
    @IBOutlet weak var ispLbl: UILabel!
    
    
    @IBOutlet weak var iplatlong: UILabel!
    @IBOutlet weak var ipTypeLbl: UILabel!
    @IBOutlet weak var threadLvlLbl: UILabel!
    
    @IBOutlet weak var uniqueUserID: UILabel!
    @IBOutlet weak var firstSeen: UILabel!
    @IBOutlet weak var sessionPH: UILabel!
    @IBOutlet weak var sessionPD: UILabel!
    @IBOutlet weak var CSScore: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var gpsLat: UILabel!
    @IBOutlet weak var gpsLong: UILabel!
    
    
    var entrypoint:BureauAPI?
    var sessionID:String?
    var locationManager = CLLocationManager()
    var location:CLLocation?
    
    var userName:String?
    var password:String?
    var isBBEnable:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioWarinnerView.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 247/255, alpha: 1).cgColor
        spinner.startAnimating()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.startUpdatingLocation()
        if isBBEnable ?? false{
            checkPriorityUser((userName ?? "") + ("@newbank.com") + (password ?? ""))
        }
        InitSDK()
    }
    
    func InitSDK(){
        let _ = UserDefaults.standard.string(forKey: "credentialId")
        sessionID = "Demo-"+NSUUID().uuidString
//        entrypoint = BureauAPI(clientID: "1b87dd79-8504-425c-90c3-56f4cad27b0f", environment: .sandbox, sessionID: sessionID ?? "", refVC: self)

        entrypoint = BureauAPI(clientID: "1896dd6b-024f-400c-b38a-623d92e39dd7", environment: .production, sessionID: sessionID ?? "", refVC: self)
        entrypoint?.fingerprintDelegate = self
        entrypoint?.setUserID(userName ?? "")
        entrypoint?.submit()
    }
    
    func loadSessionData(sessionID:String){
//        guard let serviceUrl = URL(string: ("https://api.overwatch.dev.bureau.id/v1/deviceService/fingerprint/" + sessionID)) else { return }

        guard let serviceUrl = URL(string: ("https://api.overwatch.bureau.id/v1/deviceService/fingerprint/" + sessionID)) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Basic MTg5NmRkNmItMDI0Zi00MDBjLWIzOGEtNjIzZDkyZTM5ZGQ3OjcxYmYxZDQwLWRjMjctNGE5Zi05YWE0LTZlYzllOWM2NzgwMQ==", forHTTPHeaderField: "Authorization")
//        request.setValue("Basic OTA1MmU3MjEtZTJkMS00NDk5LWFmMTItYzk2OGI5OGRjN2M5OmI3N2IzMmM0LWFlMjEtNDAwZi1hMDhhLWU0YWU0MzJhYTNjMA==", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                self.spinner.stopAnimating()
                self.spinnerView.isHidden = true
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "Failed Get Fingerprint API")
                return
            }
            print( NSString(data: data, encoding: NSUTF8StringEncoding)! as String)

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? NSDictionary {
                print(responseJSON)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinnerView.isHidden = true
                    self.updateUI(responseJSON)
                }
            }
        }.resume()
    }
    
    func updateUI(_ dic:NSDictionary){
        var riskLevel = 0
        switch dic.value(forKey: "riskLevel") as? String{
        case "VERY_HIGH":
            riskLevel = AppConstant.VIEW_NEGATIVE
            riskValue.text = "High"
        case "MEDIUM":
            riskLevel = AppConstant.VIEW_WARNING
            riskValue.text = "Medium"
        default:
            riskLevel = AppConstant.VIEW_POSITIVE
            riskValue.text = "Low"
        }
        setViewTheme(riskLevelView, ristTitle, riskValue, riskIco, riskLevel)
        
        if dic.value(forKeyPath: "mockgps") as? Bool ?? false{
            mockGpsValue.text = "Yes"
            setViewTheme(mockGpsView, mockGpsTitle, mockGpsValue, mockGpsIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "IPSecurity.VPN") as? Bool ?? false{
            vpnValue.text = "Yes"
            setViewTheme(vpnView, vpnTitle, vpnValue, vpnIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "emulator") as? Bool ?? false{
            emulatorValue.text = "Yes"
            setViewTheme(emulatorView, emulatorTitle, emulatorValue, emulatorIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "jailbreak") as? Bool ?? false{
            rootedValue.text = "Yes"
            setViewTheme(rootedView, rootedTitle, rootedValue, rootedIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "debuggable") as? Bool ?? false{
            debugValue.text = "Yes"
            setViewTheme(debugView, debugTitle, debugValue, debugIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "IPSecurity.is_crawler") as? Bool ?? false{
            crowlerValue.text = "Yes"
            setViewTheme(crowlerView, crowlerTitle, crowlerValue, crowlerIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "IPSecurity.is_proxy") as? Bool ?? false{
            proxyValue.text = "Yes"
            setViewTheme(proxyView, proxyTitle, proxyValue, proxyIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "IPSecurity.is_tor") as? Bool ?? false{
            torValue.text = "Yes"
            setViewTheme(torView, torTitle, torValue, torIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "remoteDesktop") as? Bool ?? false{
            rdValue.text = "Yes"
            setViewTheme(rdView, rdTitle, rdValue, rdIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "voiceCallDetected") as? Bool ?? false{
            cdValue.text = "Yes"
            setViewTheme(cdView, cdTitle, cdValue, cdIco, AppConstant.VIEW_NEGATIVE)
        }
        osLbl.text = (dic.value(forKeyPath: "OS") as? String)
        iplocationLbl.text = (dic.value(forKeyPath: "IPLocation.city") as? String ?? "") + "," + (dic.value(forKeyPath: "IPLocation.region") as? String ?? "") + "," + (dic.value(forKeyPath: "IPLocation.country") as? String ?? "")
        if((dic.value(forKeyPath: "GPSLocation.longitude")) as? Int == 0 || (dic.value(forKeyPath: "GPSLocation.longitude")) as? Int == 0){
            gpsLocLbl.text = "Unknown"
            gpsLat.text = "0.0"
            gpsLong.text = "0.0"
        }else{
            gpsLocLbl.text = (dic.value(forKeyPath: "GPSLocation.city") as? String ?? "") + "," + (dic.value(forKeyPath: "GPSLocation.region") as? String ?? "") + "," + (dic.value(forKeyPath: "GPSLocation.country") as? String ?? "")
            gpsLat.text = String(dic.value(forKeyPath: "GPSLocation.latitude") as? Double ?? 0.0)
            gpsLong.text = String(dic.value(forKeyPath: "GPSLocation.longitude") as? Double ?? 0.0)
        }
        fingerprintIDLbl.text = (dic.value(forKeyPath: "fingerprint") as? String)
        ispLbl.text = (dic.value(forKeyPath: "networkInformation.isp") as? String)
        ipTypeLbl.text = (dic.value(forKeyPath: "networkInformation.ipType") as? String)?.capitalized
        threadLvlLbl.text = (dic.value(forKeyPath: "IPSecurity.threat_level") as? String)?.capitalized
        firstSeen.text = String()
        var dateComponents = DateComponents()
        dateComponents.day =  -(dic.value(forKeyPath: "firstSeenDays") as? Int ?? 0)
        let currentYear = Calendar.current.component(.year, from: Date())
        dateComponents.year = currentYear
        if let date = Calendar.current.date(from: dateComponents){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Define the desired date format
            let formattedDate = dateFormatter.string(from: date)
            firstSeen.text = formattedDate
        }
        var uniqueUserIds = "1"
        if (dic.value(forKeyPath: "totalUniqueUserId") as? Int ?? 1 > 1){
            uniqueUserIds = String(dic.value(forKeyPath: "totalUniqueUserId") as? Int ?? 1) + " Risks"
        }
        uniqueUserID.text = uniqueUserIds
        userID.text = dic.value(forKeyPath: "userId") as? String
        CSScore.text = String(dic.value(forKeyPath: "confidenceScore") as? Double ?? 0.0)
    }
    @IBAction func restartAct(_ sender: Any) {
        let alertController = UIAlertController(title: "Bureau Device Intelligence", message: "Do you want to restart?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "NO", style: .cancel) { (action) in
            print("Cancel tapped")
        }
        let okayButton = UIAlertAction(title: "YES", style: .default) { (action) in
            self.navigationController?.backToViewController(viewController: MainViewController.self)
        }
        alertController.addAction(cancelButton)
        alertController.addAction(okayButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkPriorityUser(_ userID:String?){
        setBehaviouralData()
        var riskLevel = 0
        switch userID {
        case "johnwick123@newbank.com12345678", "ganesh@newbank.com12345678":
            let riskValue = Int.random(in: 10 ... 25)
            bioRiskScore.text = String(riskValue)
            bioRiskScore.textColor = AppConstant.RedTitleColor
            riskLevel = AppConstant.VIEW_NEGATIVE
        case "johnwick123@newbank.com123456789", "ganesh@newbank.com123456789":
            let riskValue = Int.random(in: 80 ... 97)
            bioRiskScore.text = String(riskValue)
            bioRiskScore.textColor = AppConstant.GreenTitleColor
            riskLevel = AppConstant.VIEW_POSITIVE
        case "marypoppins123@newbank.com123456780", "ganesh@newbank.com123456780":
            let riskValue = Int.random(in: 10 ... 25)
            bioRiskScore.text = String(riskValue)
            bioRiskScore.textColor = AppConstant.RedTitleColor
            riskLevel = AppConstant.VIEW_NEGATIVE
            break
        case "marypoppins123@newbank.com1234567890", "ganesh@newbank.com1234567890":
            let riskValue = Int.random(in: 80 ... 97)
            bioRiskScore.text = String(riskValue)
            bioRiskScore.textColor = AppConstant.GreenTitleColor
            riskLevel = AppConstant.VIEW_POSITIVE
        default:
            bioWarnView.isHidden = false
            bioResultView.isHidden = true
        }
        setViewTheme(bioRiskLevelView, bioRistTitle, bioRiskValue, bioRiskIco, riskLevel)
    }
    
    private func setBehaviouralData() {
        showBehaviouralBiometrics()
        updateDeviceBehaviouralData(self.appFamiliScore, AppConstant.medium)
        updateDeviceBehaviouralData(self.dataFamiliScore, AppConstant.High)
        updateDeviceBehaviouralData(self.exportUserScore, AppConstant.High)
        updateDeviceBehaviouralData(self.botScore, AppConstant.Low)
    }
    
    private func updateDeviceBehaviouralData(_ valueId: UILabel, _ value: String) {
        valueId.text = value
        var titleColor:UIColor?
        switch value {
        case AppConstant.High:
            titleColor = AppConstant.RedTitleColor
        case AppConstant.medium:
            titleColor = AppConstant.OrangeTitleColor
        default:
            titleColor = AppConstant.GreenTitleColor
        }
        valueId.textColor = titleColor
    }
    
    func showBehaviouralBiometrics(){
        bioWarnView.isHidden = true
        bioResultView.isHidden = false
    }
    
    func setViewTheme(_ bgView:UIView, _ titleLbl:UILabel, _ valueLbl:UILabel, _ icon:UIImageView, _ viewType: Int){
        var titleColor:UIColor?
        var bgColor:UIColor?
        switch viewType {
        case AppConstant.VIEW_WARNING:
            bgColor = AppConstant.OrangeColor
            titleColor = AppConstant.OrangeTitleColor
        case AppConstant.VIEW_NEGATIVE:
            bgColor = AppConstant.RedColor
            titleColor = AppConstant.RedTitleColor
        case AppConstant.VIEW_POSITIVE:
            bgColor = AppConstant.GreenColor
            titleColor = AppConstant.GreenTitleColor
        default:
            bgColor = AppConstant.NaturalColor
            titleColor = UIColor.lightGray
        }
        bgView.backgroundColor = bgColor
        titleLbl.textColor = titleColor
        valueLbl.textColor = titleColor
        icon.tintColor = titleColor
    }
    
}

//extension ResultVC: CLLocationManagerDelegate{
//    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        InitSDK()
//        manager.stopUpdatingLocation()
//        manager.delegate = nil
//    }
//}

extension ResultVC : PrismFingerPrintDelegate{
    func onFinished(data: [String : Any]?) {
        let statusCode = data?["statusCode"] as? Int
        if(statusCode == 200 || statusCode == 409){
            loadSessionData(sessionID: self.sessionID ?? "")
        }else if statusCode == 401{
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                let apiResponse = data?["apiResponse"] as? NSDictionary
                print("apiResponse", apiResponse ?? "")
            }
        }else{
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                let apiResponse = data?["apiResponse"] as? NSDictionary
                print("apiResponse", apiResponse ?? "")
            }
        }
        
    }
}
