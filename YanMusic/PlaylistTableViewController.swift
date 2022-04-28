//
//  PlaylistTableViewController.swift
//  YanMusic
//
//  Created by Rym- on 28/4/2022.
//

import UIKit

class PlaylistTableViewController: UITableViewController {
    let CELL_MUSIC = "musicCell"
    var allMusics: [Music] = []
    
    /*
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        if searchText.count > 0 {
            filteredMusics = allMusics.filter({ (music: Music) -> Bool in
                return (music.title?.lowercased().contains(searchText) ?? false)
            })
        } else {
            filteredMusics = allMusics
        }
        tableView.reloadData()
    }
    */
    @IBAction func playAction(_ sender: Any) {
    }
    
    func displayMessage(title: String, message: String) {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
    }
    
    func createDefaultMusics(){
        allMusics.append(Music(musicLink: "https://mgamma.123tokyo.xyz/get.php/5/5e/-u4sPnpaFEA.mp3?cid=MmEwMTo0Zjg6YzAxMDo5ZmE2OjoxfE5BfERF&h=gMEduTUfQbWle1_ujYFGDw&s=1651161620&n=Jay-Chou-Big-Ben-Official-MV", title: "周杰倫 Jay Chou【大笨鐘 Big Ben】Official MV", thumbnailLink: "https://i.ytimg.com/vi/-u4sPnpaFEA/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLCRs2-CKR5n1oejgQLrtb8Fer4S0A", length: "4:07", author: "周杰倫 Jay Chou"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDefaultMusics()
//        filteredMusics = allMusics
//
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search All Musics"
//        navigationItem.searchController = searchController
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMusics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var detailedText: String?
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MUSIC, for: indexPath)
        let music = allMusics[indexPath.row]
        cell.textLabel?.text = music.title
        if let musicAuthor = music.author, let musicLength = music.length {
            detailedText = musicAuthor + ", Duration:" + musicLength
        }
        cell.detailTextLabel?.text = detailedText
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let music = allMusics[indexPath.row]
            allMusics.remove(at: indexPath.row)
            //databaseController?.deleteBook(book: book)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if segue.identifier == "musicSegue"{
             let destination = segue.destination as! ViewController
             destination.music = allMusics[tableView.indexPathForSelectedRow!.row
]
         }
     }

}
