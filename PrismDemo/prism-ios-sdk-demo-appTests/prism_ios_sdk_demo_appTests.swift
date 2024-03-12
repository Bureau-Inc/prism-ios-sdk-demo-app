//
//  prism_ios_sdk_demo_appTests.swift
//  prism-ios-sdk-demo-appTests
//
//  Created by Apple on 10/05/23.
//

import XCTest
import prism_ios_fingerprint_sdk

@testable import prism_ios_sdk_demo_app

class prism_ios_sdk_demo_appTests: XCTestCase, PrismFingerPrintDelegate {
    
    var entrypoint:BureauAPI?
    var statusCode:Int?
    var responseMessage:String?
    private var numbersExpectation: XCTestExpectation!

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitSDK() throws {
        numbersExpectation = expectation(description: "Numbers")
        entrypoint = BureauAPI(clientID: "***", environment: .sandbox, sessionID: "Demo-"+NSUUID().uuidString)
        entrypoint?.fingerprintDelegate = self
        entrypoint?.submit()
        waitForExpectations (timeout: 100)
        if(statusCode == 200 || statusCode == 409){
            XCTAssert(true, responseMessage ?? "Not assign")
        }else{
            XCTAssert(false, responseMessage ?? "not assign")
        }
    }

    func onFinished(data: [String : Any]?) {
        statusCode = data?["statusCode"] as? Int
        if(statusCode == 200){
            responseMessage = "Device Register Successfully"
        }else if(statusCode == 409){
            responseMessage = "Session Already Exists"
        }else if statusCode == 401{
            let apiResponse = data?["apiResponse"] as? NSDictionary
            responseMessage = apiResponse?.value(forKeyPath: "errors.errorCode") as? String ?? "401 Error"
        }else{
            let apiResponse = data?["apiResponse"] as? NSDictionary
            responseMessage = apiResponse?.value(forKeyPath: "errors.message") as? String ?? "\(statusCode ?? 500) Error"
        }
        numbersExpectation.fulfill()
    }

}
