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
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var currentUsernameLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    var currentUser: FirebaseAuth.User?
    var currentUsername: String?
    
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
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password, completion: { [self] result, error in
            guard error == nil else {
                showCreateAccount()
                return
            }
            print("You have signed in")
            usernameLabel.isHidden = true
            passwordLabel.isHidden = true
            usernameTextField.isHidden = true
            passwordTextField.isHidden = true
            button.isHidden = true
            logoutButton.isHidden = false
            currentUser = result?.user
            currentUsernameLabel.text = currentUser?.email
            let defaults = UserDefaults.standard
            defaults.set(currentUser?.email, forKey: "usernameKey")
        })
        
        func showCreateAccount() {
            let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
                FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password, completion:  { [self]result, error in
                    guard error == nil else {
                        print("Account creation failed")
                        return
                    }
                    print("You have signed in")
                    usernameLabel.isHidden = true
                    passwordLabel.isHidden = true
                    usernameTextField.isHidden = true
                    passwordTextField.isHidden = true
                    button.isHidden = true
                    logoutButton.isHidden = false
                    currentUser = result?.user
                    currentUsernameLabel.text = currentUser?.email
                    let defaults = UserDefaults.standard
                    defaults.set(currentUser?.email, forKey: "usernameKey")
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
            present(alert, animated: true)
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("You have Logged out")
            usernameLabel.isHidden = false
            passwordLabel.isHidden = false
            usernameTextField.isHidden = false
            passwordTextField.isHidden = false
            button.isHidden = false
            logoutButton.isHidden = true
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "usernameKey")
            currentUsernameLabel.text = "Please log in"
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(currentUsername)
        if currentUsername != nil {
            currentUsernameLabel.text = currentUsername
            usernameLabel.isHidden = true
            passwordLabel.isHidden = true
            usernameTextField.isHidden = true
            passwordTextField.isHidden = true
            button.isHidden = true
            logoutButton.isHidden = false
        } else {
            usernameLabel.isHidden = false
            passwordLabel.isHidden = false
            usernameTextField.isHidden = false
            passwordTextField.isHidden = false
            button.isHidden = false
            logoutButton.isHidden = true
        }
    }
}
