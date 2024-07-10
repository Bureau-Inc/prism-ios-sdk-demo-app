//
//  ResultNewVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit
import bureau_id_fraud_sdk
import CoreLocation
import Charts
import CoreMotion

class ResultNewVC: BaseViewController {

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
    
    
    @IBOutlet weak var osLbl: UILabel!
    @IBOutlet weak var ipaddressLbl: UILabel!
    @IBOutlet weak var gpsLocLbl: UILabel!
    @IBOutlet weak var iplocationLbl: UILabel!
    @IBOutlet weak var fingerprintIDLbl: UILabel!
    @IBOutlet weak var sessionIDLbl: UILabel!
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
    
    @IBOutlet weak var deviceRiskListView: TagListView!
    @IBOutlet weak var appRiskListView: TagListView!
    @IBOutlet weak var networkRiskListView: TagListView!
    
    @IBOutlet weak var deviceRiskSignalView: UIView!
    @IBOutlet weak var appRiskSignalView: UIView!
    @IBOutlet weak var networkRiskSignalView: UIView!
    
    @IBOutlet weak var deviceRiskValueLbl: UILabel!
    @IBOutlet weak var appRiskValueLbl: UILabel!
    @IBOutlet weak var networkRiskValueLbl: UILabel!
    
    let motionManager = CMMotionManager()
    var locationManager = CLLocationManager()
    var location:CLLocation?
    
    var userName:String?
    var password:String?
    var isBBEnable:Bool?
    var sessionID:String?
    
    
    @IBOutlet weak var deviceOriendationView: UIView!
    @IBOutlet weak var gyroscopeView: UIView!
    @IBOutlet weak var acceleroMeterView: UIView!
    @IBOutlet weak var magneticView: UIView!
    
    var deviceOriendationGraph:BureauLineGraphView?
    var gyroscopeGraph:BureauLineGraphView?
    var acceleroMeterGraph:BureauLineGraphView?
    var magneticGraph:BureauLineGraphView?

    override func viewDidLoad() {
        super.viewDidLoad()
        bioWarinnerView.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 247/255, alpha: 1).cgColor
        spinner.startAnimating()
        BureauAPI.shared.setUserID(userName ?? "")
        BureauAPI.shared.fingerprintDelegate = self
        BureauAPI.shared.submit()
        initAllGraph()
    }
    
    func initAllGraph(){
        deviceOriendationGraph = BureauLineGraphView(frame: CGRect(x: 0, y: 0, width: deviceOriendationView.frame.width, height: deviceOriendationView.frame.height))
        deviceOriendationGraph?.titleLbl.text = "Device Orientation"
        self.deviceOriendationView.addSubview(deviceOriendationGraph!)
        
        gyroscopeGraph = BureauLineGraphView(frame: CGRect(x: 0, y: 0, width: gyroscopeView.frame.width, height: gyroscopeView.frame.height))
        gyroscopeGraph?.titleLbl.text = "Gyroscope"
        self.gyroscopeView.addSubview(gyroscopeGraph!)
        
        acceleroMeterGraph = BureauLineGraphView(frame: CGRect(x: 0, y: 0, width: acceleroMeterView.frame.width, height: acceleroMeterView.frame.height))
        acceleroMeterGraph?.titleLbl.text = "Accelerometer"
        self.acceleroMeterView.addSubview(acceleroMeterGraph!)
        
        magneticGraph = BureauLineGraphView(frame: CGRect(x: 0, y: 0, width: magneticView.frame.width, height: magneticView.frame.height))
        magneticGraph?.titleLbl.text = "Magnetic Field"
        self.magneticView.addSubview(magneticGraph!)
        
        isDeviceMotionAvailable()
        isGyroAvailable()
        isAccelerometerAvailable()
        isMagnetometerAvailable()
    }
    
    
    func loadSessionData(sessionID:String){
        guard let serviceUrl = URL(string: ("https://api.overwatch.bureau.id/v1/deviceService/fingerprint/" + sessionID)) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Basic <<TOKEN>>", forHTTPHeaderField: "Authorization")

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
                    self.setUpListView(self.deviceRiskSignalView, self.deviceRiskListView, responseJSON)
                    self.setUpListView(self.appRiskSignalView, self.appRiskListView, responseJSON)
                    self.setUpListView(self.networkRiskSignalView, self.networkRiskListView, responseJSON)
                }
            }
        }.resume()
    }
    
    func prepareChip(tagListView:TagListView, value:String, enable:Bool){
        let tagView = tagListView.addTag(value)
        if enable{
            tagView.tagBackgroundColor = AppConstant.RedColor ?? .gray
            tagView.textColor = AppConstant.RedTitleColor ?? .darkGray
        }
    }
    
    func setUpListView(_ riskSignalView:UIView, _ listView:TagListView, _ dic:NSDictionary){
        riskSignalView.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 247/255, alpha: 1).cgColor
        listView.textFont = UIFont(name: "Lexend-Regular", size: 14)!
        switch listView{
        case deviceRiskListView:
            prepareChip(tagListView: listView, value: "Mock GPS", enable: dic.value(forKeyPath: "mockgps") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "Remote Desktop", enable: dic.value(forKeyPath: "remoteDesktop") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "Rooted", enable: dic.value(forKeyPath: "jailbreak") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "Developer Mode", enable: dic.value(forKeyPath: "developerMode") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "Voice Call Detected", enable: dic.value(forKeyPath: "voiceCallDetected") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "Simulator", enable: dic.value(forKeyPath: "emulator") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "Frida Enable", enable: dic.value(forKeyPath: "fridaDetected") as? Bool ?? false)
            setLabelTheme(dic.value(forKey: "deviceRiskLevel") as? String ?? "", appRiskValueLbl)
        case appRiskListView:
            prepareChip(tagListView: listView, value: "Debuggable", enable: dic.value(forKeyPath: "debuggable") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "App Cloned", enable: false)
            prepareChip(tagListView: listView, value: "Tampered", enable: false)
            prepareChip(tagListView: listView, value: "Appstore install", enable: !(dic.value(forKeyPath: "appStoreInstall") as? Bool ?? false))
            if ((dic.value(forKeyPath: "debuggable") as? Bool ?? false) || !(dic.value(forKeyPath: "appStoreInstall") as? Bool ?? false)){
                deviceRiskValueLbl.text = AppConstant.High
                deviceRiskValueLbl.textColor = AppConstant.RedTitleColor
            }else{
                deviceRiskValueLbl.text = AppConstant.Low
                deviceRiskValueLbl.textColor = AppConstant.GreenTitleColor
            }
        default:
            prepareChip(tagListView: listView, value: "IP Security:VPN", enable: dic.value(forKeyPath: "IPSecurity.VPN") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "IP Security:TOR", enable: dic.value(forKeyPath: "IPSecurity.is_tor") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "IP Security:Proxy", enable: dic.value(forKeyPath: "IPSecurity.is_proxy") as? Bool ?? false)
            prepareChip(tagListView: listView, value: "IP Security:Crawler", enable: dic.value(forKeyPath: "IPSecurity.is_crawler") as? Bool ?? false)
            setLabelTheme(dic.value(forKeyPath: "IPSecurity.threat_level") as? String ?? "", networkRiskValueLbl)
        }
    }
    
    
    
    func updateUI(_ dic:NSDictionary){
        if isBBEnable ?? false{
            checkPriorityUser((userName ?? "") + ("@newbank.com") + (password ?? ""), dic: dic)
        }else{
            bioWarnView.isHidden = false
            bioResultView.isHidden = true
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
        sessionIDLbl.text = (dic.value(forKeyPath: "sessionId") as? String)
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
        let behaviourScore = dic.value(forKeyPath: "riskScore") as? Double ?? 0.0
        bioRiskScore.text = String(format: "%.2f", behaviourScore)
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
                deviceRiskValueLbl.text = "Very High"
            case "MEDIUM":
                bbRiskLevel = AppConstant.VIEW_WARNING
                bioRiskValue.text = "Medium"
                deviceRiskValueLbl.text = "Medium"
            default:
                bbRiskLevel = AppConstant.VIEW_POSITIVE
                bioRiskValue.text = "Low"
                deviceRiskValueLbl.text = "Low"
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
    
    func setLabelTheme(_ value:String, _ lbl:UILabel){
        let words = value.lowercased().split(separator: "_")
        let output = words.joined(separator: " ")
        lbl.text = output.capitalized
        switch output{
        case "very high", "high":
            lbl.textColor = AppConstant.RedTitleColor
        case "medium":
            lbl.textColor = AppConstant.OrangeTitleColor
        default:
            lbl.textColor = AppConstant.GreenTitleColor
        }
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

    func isDeviceMotionAvailable(){
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1  // Update interval in seconds
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (motion, error) in
                guard let self = self, let motion = motion else { return }
                let (xDegrees, yDegrees, angleDegrees) = self.deviceOrientation(from: motion)
                
                deviceOriendationGraph?.Line_1_Lbl.text = "Direction: " + String(format: "%.3f", angleDegrees)+"°"
                deviceOriendationGraph?.Line_2_Lbl.text = "x: " + String(format: "%.3f", xDegrees)+"°"
                deviceOriendationGraph?.Line_3_Lbl.text = "y: " + String(format: "%.3f", yDegrees)+"°"
                deviceOriendationGraph?.Line_4_Lbl.text = " "
                deviceOriendationGraph?.addEntry(randomDouble1: xDegrees, randomDouble2: yDegrees, randomDouble3: angleDegrees)
            }
        } else {
            print("Device motion is not available")
        }
    }
    func deviceOrientation(from motion: CMDeviceMotion) -> (Double, Double, Double) {
        let attitude = motion.attitude
        let x = attitude.pitch * 180.0 / Double.pi  // Pitch
        let y = attitude.roll * 180.0 / Double.pi   // Roll
        let angle = attitude.yaw * 180.0 / Double.pi // Yaw
        
        return (x, y, angle)
    }
    func isGyroAvailable(){
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1  // Update interval in seconds
            motionManager.startGyroUpdates(to: OperationQueue.main) { [weak self] (gyroData, error) in
                guard let self = self, let gyroData = gyroData else { return }
                let (xRate, yRate, zRate) = self.gyroscopeData(from: gyroData)
                
                gyroscopeGraph?.Line_1_Lbl.text = "x: " + String(format: "%.3f", xRate)+"rad/s"
                gyroscopeGraph?.Line_2_Lbl.text = "y: " + String(format: "%.3f", yRate)+"rad/s"
                gyroscopeGraph?.Line_3_Lbl.text = "z: " + String(format: "%.3f", zRate)+"rad/s"
                gyroscopeGraph?.Line_4_Lbl.text = " "
                gyroscopeGraph?.addEntry(randomDouble1: xRate, randomDouble2: yRate, randomDouble3: zRate)
            }
        } else {
            print("Gyroscope is not available")
        }
    }
    
    func gyroscopeData(from gyroData: CMGyroData) -> (Double, Double, Double) {
        let xRate = gyroData.rotationRate.x  // Rotation rate around x axis
        let yRate = gyroData.rotationRate.y  // Rotation rate around y axis
        let zRate = gyroData.rotationRate.z  // Rotation rate around z axis
        
        return (xRate, yRate, zRate)
    }
    
    func isAccelerometerAvailable(){
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1  // Update interval in seconds
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (accelerometerData, error) in
                guard let self = self, let accelerometerData = accelerometerData else { return }
                let (xAccel, yAccel, zAccel) = self.accelerometerData(from: accelerometerData)
                acceleroMeterGraph?.Line_1_Lbl.text = "x: " + String(format: "%.3f", xAccel)+"m/s²"
                acceleroMeterGraph?.Line_2_Lbl.text = "y: " + String(format: "%.3f", yAccel)+"m/s²"
                acceleroMeterGraph?.Line_3_Lbl.text = "z: " + String(format: "%.3f", zAccel)+"m/s²"
                acceleroMeterGraph?.Line_4_Lbl.text = " "
                acceleroMeterGraph?.addEntry(randomDouble1: xAccel, randomDouble2: yAccel, randomDouble3: zAccel)
            }
        } else {
            print("Accelerometer is not available")
        }
    }
    
    func accelerometerData(from accelerometerData: CMAccelerometerData) -> (Double, Double, Double) {
        let xAccel = accelerometerData.acceleration.x  // Acceleration along the x axis
        let yAccel = accelerometerData.acceleration.y  // Acceleration along the y axis
        let zAccel = accelerometerData.acceleration.z  // Acceleration along the z axis
        return (xAccel, yAccel, zAccel)
    }
    
    func isMagnetometerAvailable(){
        if motionManager.isMagnetometerAvailable {
            motionManager.magnetometerUpdateInterval = 0.1  // Update interval in seconds
            motionManager.startMagnetometerUpdates(to: OperationQueue.main) { [weak self] (magnetometerData, error) in
                guard let self = self, let magnetometerData = magnetometerData else { return }
                
                let (xField, yField, zField, totalField) = self.magneticFieldData(from: magnetometerData)
                magneticGraph?.Line_1_Lbl.text = "x: " + String(format: "%.3f", xField)+"μT"
                magneticGraph?.Line_2_Lbl.text = "y: " + String(format: "%.3f", yField)+"μT"
                magneticGraph?.Line_3_Lbl.text = "z: " + String(format: "%.3f", zField)+"μT"
                magneticGraph?.Line_4_Lbl.text = "Total: " + String(format: "%.3f", totalField)+"μT"
                
                magneticGraph?.addEntry(randomDouble1: xField, randomDouble2: yField, randomDouble3: zField)
            }
        } else {
            print("Magnetometer is not available")
        }
    }
    
    func magneticFieldData(from magnetometerData: CMMagnetometerData) -> (Double, Double, Double, Double) {
        let xField = magnetometerData.magneticField.x  // Magnetic field along the x axis
        let yField = magnetometerData.magneticField.y  // Magnetic field along the y axis
        let zField = magnetometerData.magneticField.z  // Magnetic field along the z axis

        let totalField = sqrt(xField * xField + yField * yField + zField * zField) // Total magnetic field

        return (xField, yField, zField, totalField)
    }
//
//    
//    func addEntry(randomDouble1: Double, randomDouble2: Double, randomDouble3: Double) {
//        counter += 1.0
//        
//        let newEntry1 = ChartDataEntry(x: counter, y: randomDouble1)
//        let newEntry2 = ChartDataEntry(x: counter, y: randomDouble2)
//        let newEntry3 = ChartDataEntry(x: counter, y: randomDouble3)
//        
//        dataEntries1.append(newEntry1)
//        dataEntries2.append(newEntry2)
//        dataEntries3.append(newEntry3)
//        
//        if let dataSet1 = lineChartView.data?.dataSets[0] as? LineChartDataSet,
//           let dataSet2 = lineChartView.data?.dataSets[1] as? LineChartDataSet,
//           let dataSet3 = lineChartView.data?.dataSets[2] as? LineChartDataSet{
//            dataSet1.append(newEntry1)
//            dataSet2.append(newEntry2)
//            dataSet3.append(newEntry3)
//            lineChartView.data?.notifyDataChanged()
//            lineChartView.notifyDataSetChanged()
//            adjustXAxisRange()
//        }
//    }
//    
//    func adjustXAxisRange() {
//        let xAxis = lineChartView.xAxis
//        xAxis.axisMinimum = 0
//        xAxis.axisMaximum = counter > 10 ? counter : 10
//        lineChartView.notifyDataSetChanged()
//    }
//}

    
}

extension ResultNewVC : PrismFingerPrintDelegate{
    func onFinished(data: [String : Any]?) {
        let statusCode = data?["statusCode"] as? Int
        if(statusCode == 200 || statusCode == 409){
            loadSessionData(sessionID: self.sessionID ?? "")
        }else if statusCode == 401{
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                let apiResponse = data?["apiResponse"] as? NSDictionary
                print("apiResponse", apiResponse ?? "")
                self.navigationController?.backToViewController(viewController: MainViewController.self)
            }
        }else{
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                let apiResponse = data?["apiResponse"] as? NSDictionary
                print("apiResponse", apiResponse ?? "")
                self.navigationController?.backToViewController(viewController: MainViewController.self)
            }
        }
        
    }
}
