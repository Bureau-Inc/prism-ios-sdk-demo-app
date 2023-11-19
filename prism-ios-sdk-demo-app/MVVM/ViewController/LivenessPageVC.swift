//
//  LivenessPageVC.swift
//  prism-ios-sdk-demo-app
//
//  Created by User on 08/08/23.
//

import UIKit
import liveness_checker_ios

class LivenessPageVC: UIViewController {

    var livenessHelper:LivenessHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livenessHelper = LivenessHelper(merchantId: "******", isRetryEnabled: true, mode: .stage, selectedLang: "en", refVC: self)
        livenessHelper?.livenessDelegate = self
    }
    
    @IBAction func startLiveness(_ sender: Any) {
        livenessHelper?.start()
    }
}

extension LivenessPageVC:LivenessCheckerDelegate{
    func onSuccessLivenessChecker(data: [String : Any]?, imageData: UIImage?) {
        print(data ?? "")
    }
    func onFailLivenessChecker(data: [String : Any]?) {
        print(data ?? "")
    }
}
