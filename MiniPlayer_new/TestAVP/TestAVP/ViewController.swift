//
//  ViewController.swift
//  TestAVP
//
//  Created by Gook whan Ahn on 2021/10/04.
//

import UIKit
import AVKit
import AVFoundation
 
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let selector = #selector(viewPlayDidFinish(notification:))
        NotificationCenter.default.addObserver(self, selector: selector, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo(name: "test", type: "mp4")
    }

    private func playVideo(name: String, type: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            // Resource Not Found
            return
        }
 
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @objc func viewPlayDidFinish(notification: Notification) {
            
    }
}

