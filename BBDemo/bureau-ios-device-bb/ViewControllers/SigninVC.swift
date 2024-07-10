//
//  SigninVC.swift
//  bureau-ios-device-bb
//
//  Created by User on 31/10/23.
//

import UIKit
import bureau_id_fraud_sdk
import Charts
import CoreMotion

class SigninVC: BaseViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userIDInnerView: UIView!
    @IBOutlet weak var pwdInnerView: UIView!
    @IBOutlet weak var deviceOriendationView: UIView!    
    var isBBEnable = false
    var sessionID:String?
    
    let motionManager = CMMotionManager()
    
    var deviceOriendationGraph:BureauLineGraphView?
    var counter = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionID = "Demo-"+NSUUID().uuidString
        BureauAPI.shared.configure(clientID: "***ClientID***", environment: .production, sessionID: sessionID ?? "", enableBehavioralBiometrics: false)
        if isBBEnable{
            BureauAPI.shared.startSubSession(NSUUID().uuidString)
        }
        userIDInnerView.layer.borderColor = UIColor.systemGray5.cgColor
        pwdInnerView.layer.borderColor = UIColor.systemGray5.cgColor
        initGraph()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
    }
    
    func initGraph(){
        deviceOriendationGraph = BureauLineGraphView(frame: CGRect(x: 0, y: 0, width: deviceOriendationView.frame.width, height: deviceOriendationView.frame.height))
        deviceOriendationGraph?.titleLbl.text = "User Behavioral Actions"
        deviceOriendationGraph?.titleIco.isHidden = false
        self.deviceOriendationView.addSubview(deviceOriendationGraph!)
        isDeviceMotionAvailable()
    }
    
    @IBAction func signinAct(_ sender: Any) {
        if userIdTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            self.showAlert(title: "Error", message: "Invalid Email")
        }else if passwordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            self.showAlert(title: "Error", message: "Invalid Password")
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "ResultNewVC") as! ResultNewVC
            VC.userName = userIdTF.text
            VC.password = passwordTF.text
            VC.isBBEnable = isBBEnable
            VC.sessionID = sessionID
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func popAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func isDeviceMotionAvailable(){
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1  // Update interval in seconds
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (motion, error) in
                guard let self = self, let motion = motion else { return }
                
                // Extract orientation data
                let (xDegrees, yDegrees, angleDegrees) = self.deviceOrientation(from: motion)
                deviceOriendationGraph?.Line_1_Lbl.text = "Direction: " + String(format: "%.3f", angleDegrees
                )+"°"
                deviceOriendationGraph?.Line_2_Lbl.text = "x: " + String(format: "%.3f", xDegrees)+"°"
                deviceOriendationGraph?.Line_3_Lbl.text = "y: " + String(format: "%.3f", yDegrees)+"°"
                deviceOriendationGraph?.Line_4_Lbl.text = " "

                deviceOriendationGraph?.addEntry(randomDouble1: xDegrees, randomDouble2: yDegrees, randomDouble3: angleDegrees)
            }
        } else {
            deviceOriendationGraph?.addEntry(randomDouble1: 0.0, randomDouble2: 0.0, randomDouble3: 0.0)
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

}

extension UIViewController{
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
