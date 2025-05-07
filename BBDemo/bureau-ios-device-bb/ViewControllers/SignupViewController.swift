//
//  SignupViewController.swift
//  bureau-ios-device-bb
//
//  Created by apple on 01/04/25.
//

import UIKit
import CoreMotion
import bureau_id_fraud_sdk

class SignupViewController: UIViewController {
    
    var isBBEnable = false
    var eventId:String?
    var analyticsData: NSDictionary?
    let motionManager = CMMotionManager()
    var tapLocations: [(x: CGFloat, y: CGFloat)] = []  // Store tap locations

    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var fullnameParentView: UIView!
    @IBOutlet weak var FullnameTF: UITextField!
    
    @IBOutlet weak var dobParentView: UIView!
    @IBOutlet weak var dobTF: UITextField!
    
    @IBOutlet weak var phoneParentView: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var emailParentView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var accountTypeParentView: UIView!
    @IBOutlet weak var accountTypeTF: UITextField!
    @IBOutlet weak var deviceOriendationView: UIView!
    var deviceOriendationGraph:BureauLineGraphView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullnameParentView.layer.borderColor = UIColor.systemGray5.cgColor
        dobParentView.layer.borderColor = UIColor.systemGray5.cgColor
        phoneParentView.layer.borderColor = UIColor.systemGray5.cgColor
        emailParentView.layer.borderColor = UIColor.systemGray5.cgColor
        accountTypeParentView.layer.borderColor = UIColor.systemGray5.cgColor
        initGraph()
        _ = initSDK()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func initSDK() -> Bool {
        eventId = NSUUID().uuidString
        let config = BureauConfig(credentialID: "<<CREDENTIAL ID>>", environment: .production, enableBehavioralBiometrics: isBBEnable, enableDebugLog: true)
        BureauAPI.shared.configure(config: config)
        BureauAPI.shared.startSubSession(NSUUID().uuidString)
        BureauAPI.shared.behavioralAnalyticsDelegate = self
        BureauAPI.shared.getBehaviouralAnalytics(25, "BureauUser", attributes: ["tag" : "login"])

    
        return BureauAPI.shared.isSDKInitializationSuccess()
    }
    
    func initGraph(){
        deviceOriendationGraph = BureauLineGraphView(frame: CGRect(x: 0, y: 0, width: deviceOriendationView.frame.width, height: deviceOriendationView.frame.height))
        deviceOriendationGraph?.titleLbl.text = "User Behavioral Actions"
        deviceOriendationGraph?.titleIco.isHidden = false
        self.deviceOriendationView.addSubview(deviceOriendationGraph!)
        startDeviceMotionTracking()
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
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signinAct(_ sender: Any) {
        guard let fullName = FullnameTF.text?.trimmingCharacters(in: .whitespaces), !fullName.isEmpty else {
            showAlert(title: "Error", message: "Full Name cannot be empty.")
            return
        }
        
        guard let dob = dobTF.text?.trimmingCharacters(in: .whitespaces), isValidDOB(dob) else {
            showAlert(title: "Error", message: "Invalid Date of Birth. Use MM/DD/YYYY format.")
            return
        }
        
        guard let phone = phoneTF.text?.trimmingCharacters(in: .whitespaces), isValidPhone(phone) else {
            showAlert(title: "Error", message: "Invalid Phone Number.")
            return
        }
        
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespaces), isValidEmail(email) else {
            showAlert(title: "Error", message: "Invalid Email Address.")
            return
        }
        
        guard let accountType = accountTypeTF.text?.trimmingCharacters(in: .whitespaces), !accountType.isEmpty else {
            showAlert(title: "Error", message: "Account Type cannot be empty.")
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
        VC.userName = fullName
        VC.isBBEnable = isBBEnable
        VC.eventId = eventId
        VC.analyticsData = self.analyticsData
        VC.tapLocations = tapLocations
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func isValidDOB(_ dob: String) -> Bool {
        let dobRegex = "^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/(19|20)\\d{2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", dobRegex)
        return predicate.evaluate(with: dob)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }

    // Phone number validation (basic check for 10-digit numbers)
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phone)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        tapLocations.append((x: location.x, y: location.y))  // Store tap coordinates
    }

}

extension SignupViewController:BehavioralAnalyticsDelegate, UIGestureRecognizerDelegate{
    func didCompleteBehaviouralAnalytics(analyticsData: NSDictionary) {
        print("didCompleteBehaviouralAnalytics-->",analyticsData)
        self.analyticsData = analyticsData
        NotificationCenter.default.post(name: NSNotification.Name("AnalyticsDataReady"), object: analyticsData)// Store data locally
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true  // Allow tap gesture to work along with SDK gestures
    }
}
