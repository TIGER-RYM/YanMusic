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
    var imgData: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 400
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
//            "X-RapidAPI-Host": "youtube-search-results.p.rapidapi.com",
//            "X-RapidAPI-Key": "ba90d6feb0msh672519f6f3e9e9ap150e3djsn71bc8cd74dd1"
            "X-RapidAPI-Host": "youtube-search-results.p.rapidapi.com",
            "X-RapidAPI-Key": "f39c14300amshabf63e8dd5e5697p19b9afjsncdc139ebeb0e"
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
    
    func requestImage(music: Music) async{
        guard let urlString = music.thumbnailLink, let url = URL(string: urlString) else {
            return
        }
        Task {
            do {
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                imgData = UIImage(data: data)
            } catch let error{
                print(error)
            }
        }
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
        for music in newMusic {
            if music.title == ""{
                newMusic.remove(at: index(ofAccessibilityElement: music))
            }
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MUSIC, for: indexPath) as! MusicTableViewCell

        // Configure the cell...
            let music = newMusic[indexPath.row]
            cell.img.image = music.musicImage
            cell.authorLabel.text = music.author
            cell.titleLabel.text = music.title
            cell.durationLabel.text = music.length
            return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "currentPlaying"{
            let destination = segue.destination as! CurrentPlayingViewController
            destination.music = newMusic[tableView.indexPathForSelectedRow!.row]
        }
    }
}
