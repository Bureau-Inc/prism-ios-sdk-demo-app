//
//  ResultVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit
import bureau_id_fraud_sdk
import CoreLocation

class ResultVC: BaseViewController {

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
    
    @IBOutlet weak var userFamiliScore: UILabel!
    @IBOutlet weak var botScore: UILabel!
    @IBOutlet weak var autoFillScore: UILabel!
    @IBOutlet weak var bPushActivityScore: UILabel!
    @IBOutlet weak var sessionDurationLbl: UILabel!
    @IBOutlet weak var swipeActivityScore: UILabel!
    @IBOutlet weak var copyPasteLbl: UILabel!
    @IBOutlet weak var fieldFocusLbl: UILabel!
    

    
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
    
    @IBOutlet weak var accModeView: UIView!
    @IBOutlet weak var accModeIco: UIImageView!
    @IBOutlet weak var accModeTitle: UILabel!
    @IBOutlet weak var accModeValue: UILabel!
    
    @IBOutlet weak var devModeView: UIView!
    @IBOutlet weak var devModeIco: UIImageView!
    @IBOutlet weak var devModeTitle: UILabel!
    @IBOutlet weak var devModeValue: UILabel!
    
    @IBOutlet weak var adbView: UIView!
    @IBOutlet weak var adbIco: UIImageView!
    @IBOutlet weak var adbTitle: UILabel!
    @IBOutlet weak var adbValue: UILabel!
    
    @IBOutlet weak var isAppstoreView: UIView!
    @IBOutlet weak var isAppstoreIco: UIImageView!
    @IBOutlet weak var isAppstoreTitle: UILabel!
    @IBOutlet weak var isAppstoreValue: UILabel!
    
    
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
    
    @IBOutlet weak var bbWarningMsgLbl: UILabel!
    
    
    var locationManager = CLLocationManager()
    var location:CLLocation?
    
    var userName:String?
    var password:String?
    var isBBEnable:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioWarinnerView.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 247/255, alpha: 1).cgColor
        spinner.startAnimating()
        InitSDK()
    }
    
    func InitSDK(){
        let _ = UserDefaults.standard.string(forKey: "credentialId")
        BureauAPI.shared.setUserID(userName ?? "")
        BureauAPI.shared.fingerprintDelegate = self
        BureauAPI.shared.submit()
    }
    
    func loadSessionData(sessionID:String){
        guard let serviceUrl = URL(string: ("https://api.overwatch.dev.bureau.id/v1/deviceService/fingerprint/" + sessionID)) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Basic <TOKEN>>", forHTTPHeaderField: "Authorization")

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
        if isBBEnable ?? false{
            checkPriorityUser((userName ?? "") + ("@newbank.com") + (password ?? ""), dic: dic)
        }
        
        var riskLevel = 0
        switch dic.value(forKey: "riskLevel") as? String{
        case "VERY_HIGH":
            riskLevel = AppConstant.VIEW_NEGATIVE
            riskValue.text = "High"
            bioRiskScore.textColor = AppConstant.RedTitleColor
        case "MEDIUM":
            riskLevel = AppConstant.VIEW_WARNING
            riskValue.text = "Medium"
            bioRiskScore.textColor = AppConstant.OrangeTitleColor
        default:
            riskLevel = AppConstant.VIEW_POSITIVE
            riskValue.text = "Low"
            bioRiskScore.textColor = AppConstant.GreenTitleColor
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
        if dic.value(forKeyPath: "voiceCallDetected") as? Bool ?? false{
            cdValue.text = "Yes"
            setViewTheme(cdView, cdTitle, cdValue, cdIco, AppConstant.VIEW_NEGATIVE)
        }
        if dic.value(forKeyPath: "developerMode") as? Bool ?? false{
            devModeValue.text = "Yes"
            setViewTheme(devModeView, devModeTitle, devModeValue, devModeIco, AppConstant.VIEW_NEGATIVE)
        }
        if !(dic.value(forKeyPath: "appStoreInstall") as? Bool ?? false){
            isAppstoreValue.text = "NO"
            setViewTheme(isAppstoreView, isAppstoreTitle, isAppstoreValue, isAppstoreIco, AppConstant.VIEW_NEGATIVE)
        }
        if (dic.value(forKeyPath: "accessibilityEnabled") as? Bool ?? false){
            accModeValue.text = "Yes"
            setViewTheme(accModeView, accModeTitle, accModeValue, accModeIco, AppConstant.VIEW_NEGATIVE)
        }
        if (dic.value(forKeyPath: "fridaDetected") as? Bool ?? false){
            adbValue.text = "Yes"
            setViewTheme(adbView, adbTitle, adbValue, adbIco, AppConstant.VIEW_NEGATIVE)
        }
        osLbl.text = (dic.value(forKeyPath: "OS") as? String)
        iplocationLbl.text = (dic.value(forKeyPath: "IPLocation.city") as? String ?? "") + "," + (dic.value(forKeyPath: "IPLocation.region") as? String ?? "") + "," + (dic.value(forKeyPath: "IPLocation.country") as? String ?? "")
        if((dic.value(forKeyPath: "GPSLocation.longitude")) as? Int == 0 || (dic.value(forKeyPath: "GPSLocation.longitude")) as? Int == 0){
            gpsLocLbl.text = "Unknown"
            gpsLat.text = "0.0"
            gpsLong.text = "0.0"
        }else{
            gpsLocLbl.text = (dic.value(forKeyPath: "GPSLocation.city") as? String ?? "") + "," + (dic.value(forKeyPath: "GPSLocation.region") as? String ?? "") + "," + (dic.value(forKeyPath: "GPSLocation.country") as? String ?? "")
            gpsLat.text = String(format: "%.5f", dic.value(forKeyPath: "GPSLocation.latitude") as? Double ?? 0.0)
            gpsLong.text = String(format: "%.5f", dic.value(forKeyPath: "GPSLocation.longitude") as? Double ?? 0.0)
        }
        
        fingerprintIDLbl.text = (dic.value(forKeyPath: "fingerprint") as? String)
        ispLbl.text = (dic.value(forKeyPath: "networkInformation.isp") as? String)
        ipaddressLbl.text = (dic.value(forKeyPath: "IP") as? String)
        ipTypeLbl.text = (dic.value(forKeyPath: "IPType") as? String)?.capitalized
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
        var uniqueUserIds = "1 Risk"
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
    
    func checkPriorityUser(_ userID:String?, dic:NSDictionary){
        setBehaviouralData(dic: dic)
//        switch userID {
//        case "johnwick123@newbank.com12345678", "ganesh@newbank.com12345678":
//            let riskValue = Int.random(in: 10 ... 25)
//            bioRiskScore.text = String(riskValue)
//            riskLevel = AppConstant.VIEW_NEGATIVE
//            break
//        case "johnwick123@newbank.com123456789", "ganesh@newbank.com123456789":
//            let riskValue = Int.random(in: 80 ... 97)
//            bioRiskScore.text = String(riskValue)
//            bioRiskScore.textColor = AppConstant.GreenTitleColor
//            riskLevel = AppConstant.VIEW_POSITIVE
//            break
//        case "marypoppins123@newbank.com123456780", "ganesh@newbank.com123456780":
//            let riskValue = Int.random(in: 10 ... 25)
//            bioRiskScore.text = String(riskValue)
//            bioRiskScore.textColor = AppConstant.RedTitleColor
//            riskLevel = AppConstant.VIEW_NEGATIVE
//            break
//        case "marypoppins123@newbank.com1234567890", "ganesh@newbank.com1234567890":
//            let riskValue = Int.random(in: 80 ... 97)
//            bioRiskScore.text = String(riskValue)
//            bioRiskScore.textColor = AppConstant.GreenTitleColor
//            break
//        default:
//            bioWarnView.isHidden = false
//            bioResultView.isHidden = true
//        }
        let behaviourScore = dic.value(forKeyPath: "riskScore") as? Double ?? 0.0
        bioRiskScore.text = String(format: "%.2f", behaviourScore)
//        switch behaviourScore{
//        case ...24.0:
//            bioRiskScore.textColor = AppConstant.RedTitleColor
//            riskLevel = AppConstant.VIEW_NEGATIVE
//        case 25.0...79.0:
//            bioRiskScore.textColor = AppConstant.OrangeTitleColor
//            riskLevel = AppConstant.VIEW_WARNING
//            break
//        default:
//            bioRiskScore.textColor = AppConstant.GreenTitleColor
//            riskLevel = AppConstant.VIEW_POSITIVE
//            break
//        }
//        setViewTheme(bioRiskLevelView, bioRistTitle, bioRiskValue, bioRiskIco, riskLevel)
    }
    
    private func setBehaviouralData(dic:NSDictionary) {
        let userSimilarityScore = (dic.value(forKeyPath: "userSimilarityScore") as? Double)
        let isTrainingSession = (dic.value(forKeyPath: "isTrainingSession") as? Bool)
        if (userSimilarityScore != nil){
            showBehaviouralBiometrics()
            var bbRiskLevel = 0
            switch dic.value(forKey: "behaviouralRiskLevel") as? String{
            case "VERY_HIGH":
                bbRiskLevel = AppConstant.VIEW_NEGATIVE
                bioRiskValue.text = "High"
            case "MEDIUM":
                bbRiskLevel = AppConstant.VIEW_WARNING
                bioRiskValue.text = "Medium"
            default:
                bbRiskLevel = AppConstant.VIEW_POSITIVE
                bioRiskValue.text = "Low"
            }
            setViewTheme(bioRiskLevelView, bioRistTitle, bioRiskValue, bioRiskIco, bbRiskLevel)
            self.userFamiliScore.text = String(format: "%.5f", userSimilarityScore ?? 0.0)
            self.botScore.text = String(dic.value(forKeyPath: "botDetectionScore") as? Double ?? 0)
            self.sessionDurationLbl.text = String((dic.value(forKeyPath: "behaviouralFeatures.sessionDurationInMS") as? Int ?? 0)/1000)

            updateDeviceBehaviouralData(self.autoFillScore, (dic.value(forKeyPath: "behaviouralFeatures.autofillActivity") as? String ?? "LOW"))
            updateDeviceBehaviouralData(self.bPushActivityScore, (dic.value(forKeyPath: "behaviouralFeatures.backgroundAppPushActivity") as? String ?? "LOW"))
            updateDeviceBehaviouralData(self.copyPasteLbl, (dic.value(forKeyPath: "behaviouralFeatures.copyPasteActivity") as? String ?? "LOW"))
            updateDeviceBehaviouralData(self.fieldFocusLbl, (dic.value(forKeyPath: "behaviouralFeatures.fieldFocusActivity") as? String ?? "LOW"))
            updateDeviceBehaviouralData(self.swipeActivityScore, (dic.value(forKeyPath: "behaviouralFeatures.swipeActivityDetected") as? String ?? "LOW"))
        }else if isTrainingSession ?? true{
            bioWarnView.isHidden = false
            bbWarningMsgLbl.text = "This is a training session for Behavioural Biometrics."
            bioResultView.isHidden = true
        }else{
            bioWarnView.isHidden = false
            bioResultView.isHidden = true
        }
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
            print(self.appdelegate?.sessionID ?? "")
            loadSessionData(sessionID: (self.appdelegate?.sessionID ?? ""))
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
