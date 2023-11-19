# Aadhaar verification - Prism SDK User Guide

Enables your user to download compliant UIDAI Aadhaar XML inside your existing Android App using offline aadhaar verification as well allows for digilocker verification method.

This SDK (Android) provides a set of screens and functionality to let your user complete Android Application itself. This reduces customer drop off as they do not need to navigate to UIDAI Aadhaar Website to download the same.

Aadhaar Offline or Digilocker is the only valid method to submit your Aadhaar identity to any RBI Regulated Entity in order to complete KYC. The Bureau SDK provides an easy to use Verification suite which will enable the most seamless customer onboarding.

## Steps in the SDK: 

### For DigiLocker:
1. User is guided to the Digilocker website to submit their Aadhaar details.
2. Input for "Aadhaar Number" are filled by the end user.
3. On continuing
    - [x] An OTP is received by the end user which should be entered in the next page.
4. Once the details entered are authenticated, the Aadhaar details are recieved by bureau backend server.
5. App backend server will make an API call to bureau backend server and fetch the details of the user.

### For aadhaar Flow:
1. User is guided to the UIDAI website to download the paperless e-KYC (Aadhaar .xml)
2. Inputs for "Aadhaar Number" & Captcha are filled by the end user.
3. On continuing
    - [x] An OTP is received by the end user which is then auto read by the SDK. The inVOID SDK only reads the then received OTP message through the screen.
4. Once the details entered are authenticated, the Aadhaar .xml is downloaded in a .zip which is password(share code) protected


## Minimum Requirements
  1. Xcode 11.0 +
  2. Deployment Target ** >13.0**

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
     // suppose if status == false "error -> [String:Any]"
     // For old aadhaarflow if status == true "userInfo -> [String:Any]" // userInfo is the complete aadhaarinformation
     
     
```

## Backend API call to get data for a user completing the KYC flow

> UserId and AuthHeader will have to be replaced in the requests below.

```Curl
// In Staging

curl --location --request GET 'https://api.overwatch.stg.bureau.id/v1/id/UserId/suppliers/offline-aadhaar' \
--header 'Authorization: Basic AuthHeader'

// In Production

curl --location --request GET 'https://api.overwatch.bureau.id/v1/id/UserId/suppliers/offline-aadhaar' \
--header 'Authorization: Basic AuthHeader'

```



#### _You can show error or Toast message based on status returns 'True' in your client side application_



