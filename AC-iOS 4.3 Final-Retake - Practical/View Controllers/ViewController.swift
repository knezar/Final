//
//  ViewController.swift
//  AC-iOS 4.3 Final-Retake - Practical
//
//  Created by C4Q on 6/1/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var messageDisplayLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func signInButton(_ sender: UIButton) {
        //        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
        //            guard error == nil else { self.messageDisplayLabel.text = error?.localizedDescription; return }
        //            guard let _ = user else {print("no user"); return }
        self.performSegue(withIdentifier: "signInSegue", sender: UIButton.self)
        //        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if let emailTextField = emailTextField.text, let passwordTextField = passwordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField, password: passwordTextField){ (user, error) in
                guard error == nil else { self.messageDisplayLabel.text = error?.localizedDescription; return }
                guard let _ = user else {print("no user"); return }
                self.performSegue(withIdentifier: "signInSegue", sender: UIButton.self)
            }
        }
    }
    
}

