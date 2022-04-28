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
    
    @IBAction func didTapButton() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
        } else {
            Task {
                do {
                    guard let urlString = music!.musicLink, let audioURL = URL(string: urlString) else { return }
                    let (data, response) = try await URLSession.shared.data(from: audioURL)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return }
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer?.play()
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

