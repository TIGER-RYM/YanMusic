//
//  LoginViewController.swift
//  YanMusic
//
//  Created by Rym- on 5/5/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("missing field")
            return
        }
        
        // Get auth instance and attempt sign,
        // if failure, send alert to create account
        // if user continues, create account
        
        // check sign in on app launch
        // all sign out with button
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password, completion: { result, error in
            guard error == nil else {
                showCreateAccount()
                return
            }
            print("You have signed in")
        })
        
        func showCreateAccount() {
            let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
                FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password, completion:  {result, error in
                    guard error == nil else {
                        print("Account creation failed")
                        return
                    }
                    print("You have signed in")
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
            present(alert, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
