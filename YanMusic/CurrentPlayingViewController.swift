//
//  ViewController.swift
//  YanMusic
//
//  Created by Rym- on 25/3/2022.
//

import UIKit
import AVFoundation

class CurrentPlayingViewController: UIViewController {
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    var music: Music?
    var audioPlayer: AVAudioPlayer?
    var musicData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isHidden = true
        loadIndicator.startAnimating()
        imageChange()
        getMusicData()
    }
    
//    func setMusicData() {
//        guard let urlString = musicLink, let url = URL(string: urlString) else { return }
//        Task{
//            do{
//                let request = URLRequest(url: url)
//                let (data, response) = try await URLSession.shared.data(for: request)
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {return}
//                musicData = data
//            }
//        }
//    }
    
    func imageChange() {
        guard let urlString = music?.thumbnailLink, let url = URL(string: urlString) else {
            return
        }
        Task {
            do {
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                image.image = UIImage(data: data)
            } catch let error{
                print(error)
            }
        }
    }
    
    func getMusicData() {
        guard let musicID = music?.musicID else { return }
        let headers = [
                            "X-RapidAPI-Host": "youtube-mp36.p.rapidapi.com",
                            "X-RapidAPI-Key": "ba90d6feb0msh672519f6f3e9e9ap150e3djsn71bc8cd74dd1"
                        ]
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "youtube-mp36.p.rapidapi.com"
        uc.path = "/dl"
        uc.queryItems = [
            URLQueryItem(name: "id", value: musicID)
        ]
        guard let urlString = uc.url else {
            print("Invalid URL.")
            return
        }
        Task{
            do{
                var request = URLRequest(url: urlString)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers
                let(data, _) = try await URLSession.shared.data(for: request)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let link = json["link"] as? String
                
                guard let urlString = link, let url = URL(string: urlString) else { return }
                Task{
                    do{
                        let request = URLRequest(url: url)
                        let (data, response) = try await URLSession.shared.data(for: request)
                        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {return}
                        musicData = data
                        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
                            audioPlayer.pause()
                        } else {
                            do {
                                try AVAudioSession.sharedInstance().setMode(.default)
                                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                                guard let data = musicData else {
                                    return
                                }
                
                                audioPlayer = try AVAudioPlayer(data: data)
                                audioPlayer?.play()
                                loadIndicator.stopAnimating()
                                loadIndicator.hidesWhenStopped = true
                                button.isHidden = false
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
            }
        }
    }
//        do{
//            if let id = music?.musicID{
//                let headers = [
//                    "X-RapidAPI-Host": "youtube-mp36.p.rapidapi.com",
//                    "X-RapidAPI-Key": "ba90d6feb0msh672519f6f3e9e9ap150e3djsn71bc8cd74dd1"
//                ]
//                var uc = URLComponents()
//                uc.scheme = "https"
//                uc.host = "youtube-mp3-download1.p.rapidapi.com"
//                uc.path = "dl"
//                uc.queryItems = [
//                    URLQueryItem(name: "id", value: id)
//                ]
//                print(uc.url)
//                if let urlString = uc.url {
//                    let urlRequest = NSMutableURLRequest(url: urlString,
//                                                            cachePolicy: .useProtocolCachePolicy,
//                                                        timeoutInterval: 10.0)
//                    urlRequest.httpMethod = "GET"
//                    urlRequest.allHTTPHeaderFields = headers
//                    let _: Void = URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
//                        guard let data = data, error == nil else { return }
//                        do {
//                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//                            self.music?.musicLink = json["link"] as? String
//                        } catch let error as NSError {
//                            print(error)
//                        }
//                    }).resume()
//                }
//            }
//        }
    
    @IBAction func playAction(_ sender: Any){
        print("clicked")
        if let audioPlayer = audioPlayer{
            if audioPlayer.isPlaying {
                audioPlayer.pause()
                print("music paused")
            } else {
                audioPlayer.play()
                print("music played")
            }
        }
    }
}
