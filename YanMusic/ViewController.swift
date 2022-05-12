//
//  ViewController.swift
//  YanMusic
//
//  Created by Rym- on 25/3/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    var music: Music?
    var audioPlayer: AVAudioPlayer?
    var musicData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageChange()
        getMusicData()
    }
    
    func imageChange() {
        guard let urlString = music!.thumbnailLink, let url = URL(string: urlString) else {
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
        guard let urlString = music!.musicLink, let url = URL(string: urlString) else {
            return
        }
        Task {
            do {
                let request = URLRequest(url: url)
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return
                }
                musicData = data
            } catch let error{
                print(error)
            }
        }
    }
    
    @IBAction func didTapButton() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

                guard let musicData = musicData else {
                    return
                }
                
                audioPlayer = try AVAudioPlayer(data: musicData)
                audioPlayer?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

