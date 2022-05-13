//
//  SearchViewController.swift
//  YanMusic
//
//  Created by Rym- on 6/5/2022.
//

import UIKit
import Foundation

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    let CELL_MUSIC = "musicCell"
    var newMusic = [Music]()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
       
        navigationItem.hidesSearchBarWhenScrolling = false
        
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
       
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func requestMusic(_ musicName: String) async {
        let headers = [
            "X-RapidAPI-Host": "youtube-search-results.p.rapidapi.com",
            "X-RapidAPI-Key": "ba90d6feb0msh672519f6f3e9e9ap150e3djsn71bc8cd74dd1"
        ]
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "youtube-search-results.p.rapidapi.com"
        uc.path = "/youtube-search/"
        uc.queryItems = [
            URLQueryItem(name: "q", value: musicName)
        ]
        guard let urlString = uc.url else {
            print("Invalid URL.")
            return
        }
        let urlRequest = NSMutableURLRequest(url: urlString,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        let _: Void = URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { [self](data, response, error) in
            guard let data = data, error == nil else { return }
            Task{
                do {
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                    }
                    
                    let decoder = JSONDecoder()
                    let volumeData =
                        try decoder.decode(VolumeData.self, from: data)
                    
                    if let musics = volumeData.musics {
                        newMusic.append(contentsOf: musics)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }).resume()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        newMusic.removeAll()
        tableView.reloadData()
        
        guard let searchText = searchBar.text else{
            return
        }
        
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        
        URLSession.shared.invalidateAndCancel()
        
        Task {await requestMusic(searchText)}
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newMusic.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MUSIC, for: indexPath)

        // Configure the cell...
        let music = newMusic[indexPath.row]
        cell.textLabel?.text = music.title
        cell.detailTextLabel?.text = music.author
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "currentPlaying"{
            let destination = segue.destination as! ViewController
            destination.music = newMusic[tableView.indexPathForSelectedRow!.row]
        }
    }
}
