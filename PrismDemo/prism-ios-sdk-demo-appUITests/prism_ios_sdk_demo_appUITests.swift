//
//  prism_ios_sdk_demo_appUITests.swift
//  prism-ios-sdk-demo-appUITests
//
//  Created by Apple on 11/05/23.
//

import XCTest

final class prism_ios_sdk_demo_appUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.staticTexts["Login with Bureau"]/*[[".buttons[\"Login with Bureau\"].staticTexts[\"Login with Bureau\"]",".staticTexts[\"Login with Bureau\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["“prism-ios-sdk-demo-app” Wants to Use “auth0.com” to Sign In"].scrollViews.otherElements.buttons["Continue"].tap()
        app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.otherElements["main"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=2264\"].webViews.webViews.webViews",".otherElements[\"Enter your organization | AdhaarSDK\"].otherElements[\"main\"]",".otherElements[\"main\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.children(matching: .textField).element.tap()
        
        let pKey = app/*@START_MENU_TOKEN@*/.keys["P"]/*[[".keyboards.keys[\"P\"]",".keys[\"P\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()
        pKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        rKey.tap()
        
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        iKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let mKey = app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()
        mKey.tap()
        app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.buttons["Continue"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=2264\"].webViews.webViews.webViews",".otherElements[\"Enter your organization | AdhaarSDK\"]",".otherElements[\"main\"].buttons[\"Continue\"]",".buttons[\"Continue\"]",".webViews.webViews.webViews"],[[[-1,4,1],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.otherElements["main"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=2264\"].webViews.webViews.webViews",".otherElements[\"Log in | AdhaarSDK\"].otherElements[\"main\"]",".otherElements[\"main\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.children(matching: .textField).element.tap()
        app.staticTexts["Use nic.m@bureau.com”"].tap()
        app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.buttons["Continue"]/*[[".otherElements[\"BrowserView?IsPageLoaded=true&WebViewProcessID=2264\"].webViews.webViews.webViews",".otherElements[\"Log in | AdhaarSDK\"]",".otherElements[\"main\"].buttons[\"Continue\"]",".buttons[\"Continue\"]",".webViews.webViews.webViews"],[[[-1,4,1],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element.tap()
        app.alerts["Allow “Prism iOS” to track your activity across other companies’ apps and websites?"].scrollViews.otherElements.buttons["Allow"].tap()
        app.alerts["Allow “Prism iOS” to use your location?"].scrollViews.otherElements.buttons["Allow While Using App"].tap()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
