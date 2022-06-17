# Aadhaar verification - Prism SDK User Guide

## DigiLocker Flow: 
Aadhaar Offline or Digilocker is the only valid method to submit your Aadhaar identity to any RBI Regulated Entity in order to complete KYC. The Bureau SDK provides an easy to use Verification suite which will enable the most seamless customer onboarding.

> Aadhar old and new flow will coming soon.

### Steps in the SDK: 
1. User is guided to the Digilocker website to submit their Aadhaar details.
2. Input for "Aadhaar Number" are filled by the end user.
3. On continuing
    - [x] An OTP is received by the end user which should be entered in the next page.
4. Once the details entered are authenticated, the Aadhaar details are recieved by bureau backend server.
5. App backend server will make an API call to bureau backend server and fetch the details of the user.

## Minimum Requirements
  1. Xcode 11.0 +
  2. Deployment Target **< 13.0**

## Integration Of SDK
  1. Drag and drop the prism_ios_native_sdk.xcframework into the project
  2. Verify the prism_ios_native_sdk.xcframework is included under frameworks, Libraries, and Embedded content(Under Targets)
 
      - It should be Embed & Sign option

## Initialize Of SDK

```Swift
  
  var entryPoint:PrismEntryPoint?
  
  // Initialize PRISM ENTRYPOINT
  entryPoint = PrismEntryPoint.init(merchantId: "***CLIENT KEY ***", userId: "*** UNIQUE USER ID ***", successRedirectURL: "*** URL ***", failureRedirectURL: "*** URL ***", runOnProduction: .stage,refVC: self)
  
  // runOnProduction have .stage, .production, .sandbox 
  entryPoint?.prismEntryDelegate = self
  
```

## Usage & Functional Call

```Swift

// Adding config to priortize the flows by which Aadhaar data is to be taken can be added multiple times    
// The above order of methods can be rearranged based on priority
entryPoint?.addConfig(config: [.digilockerFlow, .myAadhaarUidaiFlow, .residentUidaiAadhaarFlow])

// KYC initiate call
entryPoint?.beginKYCFLow()

```
###### NOTE:
###### 1._UserId and MerchantId** are mandatory fields and should not be empty. UserId is a unique string that represents each unique user trying the flow._ <br/>_At least 2 methods should be set as first and second priority when adding config to sdk_


## Response returned from the SDK

```Swift

// Shoulde need to extent the PrismDelegate for your View controller

extension ViewController:PrismEntryPointDelegate { }

// onKYCFinished Delegate will trigger after success or failure Digilocker flow completion
func onKYCFinished(data: [String : Any]?) { }
     // data returning blow key values
     // "status -> Bool"
     // suppose if status == false "errorCode -> String"
     
```
#### _You can show error or Toast message based on status returns 'True' in your client side application_



