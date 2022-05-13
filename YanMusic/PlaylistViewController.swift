//
//  PlaylistViewController.swift
//  YanMusic
//
//  Created by Rym- on 13/5/2022.
//

import UIKit

class PlaylistViewController: UIViewController {
    @IBOutlet weak var currentUserLabel: UILabel!
    var currentUsername: String?
    
    @IBAction func updateAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let value = defaults.string(forKey: "usernameKey") {
            currentUserLabel.text = value
        } else {
            currentUserLabel.text = "Please log in"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userPage"{
            let destination = segue.destination as! LoginViewController
            let defaults = UserDefaults.standard
            if let value = defaults.string(forKey: "usernameKey") {
                destination.currentUsername = value
            }
        }
    }
}
