//
//  PlaylistTableViewController.swift
//  YanMusic
//
//  Created by Rym- on 28/4/2022.
//

import UIKit
import FirebaseFirestore

class PlaylistTableViewController: UITableViewController {
    let CELL_MUSIC = "musicCell"
    var allMusics: [String] = []

//    @IBAction func playAction(_ sender: Any) {
//    }
//
//    func displayMessage(title: String, message: String) {
//         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//         alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//         self.present(alertController, animated: true, completion: nil)
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        let musicRef = database.document("music/playlist")
        musicRef.getDocument{ snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            print(data)
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allMusics.count
    }
}
