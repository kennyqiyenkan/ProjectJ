//
//  ViewController.swift
//  ProjectJ
//
//  Created by Kenny Kan on 2017-10-31.
//  Copyright © 2017 JK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var label_authEnabled: UILabel!
  @IBOutlet weak var textArea_AuthResponse: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    label_authEnabled.text = "Auth: \(String(describing: BiometricAuth.enabled))"
  }

  @IBAction func toggleAuthEnabled(_ sender: Any) {
    BiometricAuth.enabled ? BiometricAuth.disable() : BiometricAuth.enable()
    label_authEnabled.text = "Auth: \(String(describing: BiometricAuth.enabled))"
  }
  
  @IBAction func checkAuthorization(_ sender: Any) {
    self.textArea_AuthResponse.text = ""
    BiometricAuth.checkAuthorization() {
      status in
      self.textArea_AuthResponse.text = status.stringValue()
    }
  }
}

