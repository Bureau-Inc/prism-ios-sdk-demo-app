//
//  CheckoutViewController.swift
//  bureau-ios-device-bb
//
//  Created by apple on 01/04/25.
//

import UIKit
import CoreMotion
import bureau_id_fraud_sdk

class CheckoutViewController: UIViewController {
    
    var isBBEnable = false
    var eventId:String?
    var analyticsData: NSDictionary?
    let motionManager = CMMotionManager()
    var tapLocations: [(x: CGFloat, y: CGFloat)] = []  // Store tap locations

    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var cartNoParentView: UIView!
    @IBOutlet weak var cardNoTF: UITextField!
    
    @IBOutlet weak var ExpiryParentView: UIView!
    @IBOutlet weak var ExpiryTF: UITextField!
    
    @IBOutlet weak var cvvParentView: UIView!
    @IBOutlet weak var cvvTF: UITextField!
    
    @IBOutlet weak var nameOfCardParentView: UIView!
    @IBOutlet weak var nameOfCardTF: UITextField!
    @IBOutlet weak var deviceOriendationView: UIView!
    
    var deviceOriendationGraph:BureauLineGraphView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartNoParentView.layer.borderColor = UIColor.systemGray5.cgColor
        ExpiryParentView.layer.borderColor = UIColor.systemGray5.cgColor
        cvvParentView.layer.borderColor = UIColor.systemGray5.cgColor
        nameOfCardParentView.layer.borderColor = UIColor.systemGray5.cgColor
        initGraph()
        _ = initSDK()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func initSDK() -> Bool {
        eventId = NSUUID().uuidString
        let config = BureauConfig(credentialID: "<<CREDENTIAL ID>>", eventId: eventId ?? "", environment: .production, enableBehavioralBiometrics: isBBEnable, enableDebugLog: true)
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
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkOutAct(_ sender: Any) {
        guard let cardNumber = cardNoTF.text?.trimmingCharacters(in: .whitespaces), isValidCardNumber(cardNumber) else {
            showAlert(title: "Error", message: "Invalid Card Number. It must be 16 digits.")
            return
        }
        
        guard let expiryDate = ExpiryTF.text?.trimmingCharacters(in: .whitespaces), isValidExpiryDate(expiryDate) else {
            showAlert(title: "Error", message: "Invalid Expiry Date. Use MM/YY format and ensure it's a future date.")
            return
        }
        
        guard let cvv = cvvTF.text?.trimmingCharacters(in: .whitespaces), isValidCVV(cvv) else {
            showAlert(title: "Error", message: "Invalid CVV. It must be 3 digits.")
            return
        }
        
        guard let nameOnCard = nameOfCardTF.text?.trimmingCharacters(in: .whitespaces), !nameOnCard.isEmpty else {
            showAlert(title: "Error", message: "Name on Card cannot be empty.")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
        VC.userName = nameOnCard
        VC.isBBEnable = isBBEnable
        VC.eventId = eventId
        VC.analyticsData = self.analyticsData
        VC.tapLocations = tapLocations
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func isValidCardNumber(_ cardNumber: String) -> Bool {
        let cardRegex = "^[0-9]{16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", cardRegex)
        return predicate.evaluate(with: cardNumber)
    }
    
    // Expiry Date: Should be in MM/YY format and in the future
    func isValidExpiryDate(_ expiry: String) -> Bool {
        let expiryRegex = "^(0[1-9]|1[0-2])/[0-9]{2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expiryRegex)
        
        guard predicate.evaluate(with: expiry) else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        guard let expiryDate = dateFormatter.date(from: expiry) else { return false }
        
        return expiryDate > Date()
    }
    
    // CVV: Should be exactly 3 digits
    func isValidCVV(_ cvv: String) -> Bool {
        let cvvRegex = "^[0-9]{3}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", cvvRegex)
        return predicate.evaluate(with: cvv)
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
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        tapLocations.append((x: location.x, y: location.y))  // Store tap coordinates
    }
}

extension CheckoutViewController:BehavioralAnalyticsDelegate, UIGestureRecognizerDelegate{
    func didCompleteBehaviouralAnalytics(analyticsData: NSDictionary) {
        print("didCompleteBehaviouralAnalytics-->",analyticsData)
        self.analyticsData = analyticsData
        NotificationCenter.default.post(name: NSNotification.Name("AnalyticsDataReady"), object: analyticsData)// Store data locally
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true  // Allow tap gesture to work along with SDK gestures
        }
}
