//
//  BiometricAuth.swift
//  ProjectJ
//
//  Created by Kenny Kan on 2017-10-31.
//  Copyright © 2017 JK. All rights reserved.
//

import LocalAuthentication

class BiometricAuth {
  enum Status {
    case Success
    case Failed
    case NotEnabled
    case NotAvailable
    case Error
    
    func stringValue() -> String {
      switch self {
      case .Success:
        return "Authentication Successful"
      case .Failed:
        return "Authentication Failed"
      case .NotEnabled:
        return "Biometric Authentication not enabled"
      case .NotAvailable:
        return "Biometric Authentication not available on this device"
      case .Error:
        return "An error occurred"
      }
    }
  }
  
  static var enabled: Bool = false
  
  static func enable()  { enabled = true  }
  static func disable() { enabled = false }
  
  static func checkAuthorization(callback: @escaping (Status) -> Void) {
    guard enabled else {
      callback(.NotEnabled)
      return
    }
    
    let context = LAContext()
    let reason = "Please authenticate to access your list."
    
    var authError: NSError?
    
    guard #available(iOS 8.0, macOS 10.12.1, *) else {
      callback(.NotAvailable)
      return
    }
    
    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
      print(authError ?? "Could not evaluate policy")
      callback(.Error)
      return
    }
    
    let mainThreadCallback: ((Status) -> Void) = {
      status in
      DispatchQueue.main.async {
        callback(status)
      }
    }
    
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
      success, evaluateError in
      if success {
        // User authenticated successfully, take appropriate action
        mainThreadCallback(.Success)
      } else {
        // User did not authenticate successfully, look at error and take appropriate action
        print(evaluateError!.localizedDescription)
        mainThreadCallback(.Failed)
      }
    }
  }
}
