//
//  PlaylistViewController.swift
//  YanMusic
//
//  Created by Rym- on 13/5/2022.
//

import UIKit
import FirebaseFirestore

class PlaylistViewController: UIViewController {
    @IBOutlet weak var currentUserLabel: UILabel!
    var currentUsername: String?
    let database = Firestore.firestore()
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var musicID: UILabel!
    
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
        let musicRef = database.document("music/playlist")
        musicRef.getDocument{ snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            guard let text = data["musicId"] as? String else {return}
            DispatchQueue.main.async {
                self.musicID.text = text
            }
        }
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
//extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let musicCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)
//        var content = musicCell.defaultContentConfiguration()
//        musicCell.contentConfiguration = content
//        
//        return musicCell
//    }
//}
