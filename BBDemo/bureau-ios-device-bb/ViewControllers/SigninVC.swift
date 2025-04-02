//
//  SigninVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit
import bureau_id_fraud_sdk
import DGCharts
import CoreMotion

class SigninVC: BaseViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userIDInnerView: UIView!
    @IBOutlet weak var pwdInnerView: UIView!
    @IBOutlet weak var deviceOriendationView: UIView!
    var isBBEnable = false
    var eventId:String?
    var analyticsData: NSDictionary?

    let motionManager = CMMotionManager()
    
    var deviceOriendationGraph:BureauLineGraphView?
    var counter = 0.0
    var tapLocations: [(x: CGFloat, y: CGFloat)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventId = NSUUID().uuidString
        userIDInnerView.layer.borderColor = UIColor.systemGray5.cgColor
        pwdInnerView.layer.borderColor = UIColor.systemGray5.cgColor
        _ = initSDK()
        initGraph()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func initSDK() -> Bool {
        eventId = NSUUID().uuidString
        let config = BureauConfig(credentialID: "<<CREDENTIAL ID>>", eventId: eventId ?? "", environment: .production, enableBehavioralBiometrics: isBBEnable, enableDebugLog: true)
        BureauAPI.shared.configure(config: config)
        BureauAPI.shared.localSignalDelegate = self
        BureauAPI.shared.utilityDelegate = self
        BureauAPI.shared.enableRiskMonitoring(frequency: .instant)
        BureauAPI.shared.startMonitoringRiskSignals()
        BureauAPI.shared.startSubSession(NSUUID().uuidString)
//            
        BureauAPI.shared.behavioralAnalyticsDelegate = self
        BureauAPI.shared.getBehaviouralAnalytics(25, "BureauUser", attributes: ["tag" : "login"])
        return BureauAPI.shared.isSDKInitializationSuccess()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
        BureauAPI.shared.stopSubSession()
    }
    
    func initGraph(){
        deviceOriendationGraph = BureauLineGraphView(frame: CGRect(x: 0, y: 0, width: deviceOriendationView.frame.width, height: deviceOriendationView.frame.height))
        deviceOriendationGraph?.titleLbl.text = "User Behavioral Actions"
        deviceOriendationGraph?.titleIco.isHidden = false
        self.deviceOriendationView.addSubview(deviceOriendationGraph!)
        startDeviceMotionTracking()
    }
    
    @IBAction func signinAct(_ sender: Any) {
        if userIdTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            self.showAlert(title: "Error", message: "Invalid Email")
        }else if passwordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            self.showAlert(title: "Error", message: "Invalid Password")
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
            VC.userName = userIdTF.text
            VC.password = passwordTF.text
            VC.isBBEnable = isBBEnable
            VC.eventId = eventId
            VC.analyticsData = self.analyticsData
            VC.tapLocations = tapLocations
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func startDeviceMotionTracking() {
        motionManager.startTrackingMotion { [weak self] xDegrees, yDegrees, angleDegrees in
            guard let self = self else { return }
            deviceOriendationGraph?.Line_1_Lbl.text = "Direction: \(String(format: "%.3f", angleDegrees))°"
            deviceOriendationGraph?.Line_2_Lbl.text = "x: \(String(format: "%.3f", xDegrees))°"
            deviceOriendationGraph?.Line_3_Lbl.text = "y: \(String(format: "%.3f", yDegrees))°"
            deviceOriendationGraph?.Line_4_Lbl.text = " "
            deviceOriendationGraph?.addEntry(randomDouble1: xDegrees, randomDouble2: yDegrees, randomDouble3: angleDegrees)
        }
    }
    
    func deviceOrientation(from motion: CMDeviceMotion) -> (Double, Double, Double) {
        let attitude = motion.attitude
        let x = attitude.pitch * 180.0 / Double.pi  // Pitch
        let y = attitude.roll * 180.0 / Double.pi   // Roll
        let angle = attitude.yaw * 180.0 / Double.pi // Yaw
        return (x, y, angle)
    }
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        tapLocations.append((x: location.x, y: location.y))  // Store tap coordinates
    }
}

extension UIViewController{
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SigninVC: LocalSignalDelegate, UIGestureRecognizerDelegate {
    func deviceLocation(isMocked: Bool) {
        if isMocked {
            print("APP running in MOCK LOCATION")
        }
    }
    
    func appDebugMode(enable: Bool) {
        if enable {
            print("APP running in DEBUG MODE")
        }
    }
    
    func device(isJailBreak: Bool) {
        if isJailBreak {
            print("This device is jailBroken!!!")
        }
        else {
            print("This device is NOT jailBroken!!!")
        }
    }
    
    func isVPNEnable(enable: Bool) {
        if enable {
            print("VPN is enable")
        }
        else {
            print("VPN is not enable")
        }
    }
    
    func voiceCall(isDetected: Bool) {
        isDetected == true ? print("VoiceCall is Detected"): print("VoiceCall is not Detected")
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true  // Allow tap gesture to work along with SDK gestures
    }
}

extension SigninVC: UtilityDelegate {
    func getPayload(payload: NSDictionary) {
        print(payload)
    }
}

extension SigninVC:BehavioralAnalyticsDelegate{
    func didCompleteBehaviouralAnalytics(analyticsData: NSDictionary) {
        print("didCompleteBehaviouralAnalytics-->",analyticsData)
        self.analyticsData = analyticsData
        NotificationCenter.default.post(name: NSNotification.Name("AnalyticsDataReady"), object: analyticsData)// Store data locally
    }
}


extension CMMotionManager {
    func startTrackingMotion(updateInterval: TimeInterval = 0.1, updateHandler: @escaping (Double, Double, Double) -> Void) {
        if self.isDeviceMotionAvailable {
            self.deviceMotionUpdateInterval = updateInterval
            self.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
                guard let motion = motion else { return }
                let (xDegrees, yDegrees, angleDegrees) = motion.getDeviceOrientation()
                updateHandler(xDegrees, yDegrees, angleDegrees)
            }
        } else {
            updateHandler(0.0, 0.0, 0.0)
            print("Device motion is not available")
        }
    }
}

extension CMDeviceMotion {
    func getDeviceOrientation() -> (Double, Double, Double) {
        let x = self.attitude.pitch * 180.0 / Double.pi  // Pitch
        let y = self.attitude.roll * 180.0 / Double.pi   // Roll
        let angle = self.attitude.yaw * 180.0 / Double.pi // Yaw
        return (x, y, angle)
    }
}
