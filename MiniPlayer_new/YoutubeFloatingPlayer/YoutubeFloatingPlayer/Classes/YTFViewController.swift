//
//  YTDViewController.swift
//  YTDraggablePlayer
//
//  Created by Ana Paula on 5/23/16.
//  Copyright © 2016 Ana Paula. All rights reserved.
//

import UIKit
import AVFoundation.AVPlayer

class YTFViewController: UIViewController {
    
    @IBOutlet weak var miniPlay: UIButton!
    @IBOutlet weak var miniClose: UIButton!

    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var fullscreen: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var minimizeButton: YTFPopupCloseButton!
    @IBOutlet weak var playerControlsView: UIView!
    @IBOutlet weak var backPlayerControlsView: UIView!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var progress: CustomProgress!
    @IBOutlet weak var entireTime: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var progressIndicatorView: UIActivityIndicatorView!
    var delegate: UITableViewDelegate?
    var dataSource: UITableViewDataSource?
    var tableCellNibName: String?
    var isOpen: Bool = false
    
    var isPlaying: Bool = false
    var isFullscreen: Bool = false
    var dragginSlider: Bool = false
    var isMinimized: Bool = false
    var hideTimer: Timer?
    var currentUrlIndex: Int = 0 {
        didSet {
            if (playerView != nil) {
                // Finish playing all items
                if (currentUrlIndex >= urls!.count) {
                    // Go back to first tableView item to loop list
                    currentUrlIndex = 0
                    selectFirstRowOfTable()
                } else {
                    playIndex(index: currentUrlIndex)
                }
            }
        }
    }
    var urls: [NSURL]? {
        didSet {
            if (playerView != nil) {
                currentUrlIndex = 0
            }
        }
    }
    
    var playerControlsFrame: CGRect?
    var playerViewFrame: CGRect?
    var tableViewContainerFrame: CGRect?
    var playerViewMinimizedFrame: CGRect?
    var minimizedPlayerFrame: CGRect?
    var initialFirstViewFrame: CGRect?
    var viewMinimizedFrame: CGRect?
    var restrictOffset: Float?
    var restrictTrueOffset: Float?
    var restictYaxis: Float?
    var transparentView: UIView?
    var onView: UIView?
    var playerTapGesture: UITapGestureRecognizer?
    var panGestureDirection: UIPanGestureRecognizerDirection?
    var touchPositionStartY: CGFloat?
    var touchPositionStartX: CGFloat?
    
    enum UIPanGestureRecognizerDirection {
        case Undefined
        case Up
        case Down
        case Left
        case Right
    }
    
    override func viewDidLoad() {
        initPlayerWithURLs()
        initViews()
        playerView.delegate = self
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calculateFrames()
    }
    
    func initPlayerWithURLs() {
        if (isMinimized) {
            expandViews()
        }
        playIndex(index: currentUrlIndex)
    }
    
    func initViews() {
        self.view.backgroundColor = UIColor.clear
        self.view.alpha = 0.0
        playerControlsView.alpha = 0.0
        backPlayerControlsView.alpha = 0.0
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(YTFViewController.panAction))
        playerView.addGestureRecognizer(gesture)
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.rowHeight = CGFloat(76)
        tableView.register(UINib(nibName: tableCellNibName!, bundle: nil), forCellReuseIdentifier: tableCellNibName!)
    }
    
    func calculateFrames() {
        self.initialFirstViewFrame = self.view.frame
        self.playerViewFrame = self.playerView.frame
        self.tableViewContainerFrame = self.tableViewContainer.frame
        self.playerViewMinimizedFrame = self.playerView.frame
        self.viewMinimizedFrame = self.tableViewContainer.frame
        self.playerControlsFrame = self.playerControlsView.frame
        
        playerView.translatesAutoresizingMaskIntoConstraints = true
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = true
        playerControlsView.translatesAutoresizingMaskIntoConstraints = true
        backPlayerControlsView.translatesAutoresizingMaskIntoConstraints = true
        tableViewContainer.frame = self.initialFirstViewFrame!
        self.playerControlsView.frame = self.playerControlsFrame!
        
        transparentView = UIView.init(frame: initialFirstViewFrame!)
        transparentView?.backgroundColor = UIColor.black
        transparentView?.alpha = 0.0
        onView?.addSubview(transparentView!)
        
        self.restrictOffset = Float(self.initialFirstViewFrame!.size.width) - 200
        self.restrictTrueOffset = Float(self.initialFirstViewFrame!.size.height) - 180
        self.restictYaxis = Float(self.initialFirstViewFrame!.size.height - playerView.frame.size.height)
        
    }
    
    @IBAction func minimizeButtonTouched(_ sender: Any) {
        minimizeViews()
    }
    
    func selectFirstRowOfTable() {
        let rowToSelect:NSIndexPath = NSIndexPath(row: 0, section: 0)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.scrollToRow(at: rowToSelect as IndexPath, at: .top, animated: false)
        })
    }
    
}


extension YTFViewController {

    
    @IBAction func miniPlayTouched(_ sender: Any) {
        if (isPlaying) {
            playerView.pause()
        } else {
            playerView.play()
        }
    }

    @IBAction func miniCloseTouched(_ sender: Any) {

    }
    
    @IBAction func playTouched(_ sender: Any) {
        if (isPlaying) {
            playerView.pause()
        } else {
            playerView.play()
        }
    }
    
    
    @IBAction func fullScreenTouched(_ sender: Any) {
        if (!isFullscreen) {
            setPlayerToFullscreen()
        } else {
            setPlayerToNormalScreen()
        }
    }
    
    @IBAction func touchDragInsideSlider(_ sender: Any) {
        dragginSlider = true
    }
    
    
    @IBAction func valueChangedSlider(_ sender: Any) {
        playerView.currentTime = Double(slider.value)
        playerView.play()
    }
    
    @IBAction func touchUpInsideSlider(_ sender: Any) {
        dragginSlider = false
    }
    
    func playIndex(index: Int) {
        print("Index \(index)")
        playerView.url = urls![index]
        playerView.play()
        progressIndicatorView.isHidden = false
        progressIndicatorView.startAnimating()
    }
}

extension YTFViewController: PlayerViewDelegate {
    
    func playerVideo(player: PlayerView, statusPlayer: PVStatus, error: NSError?) {
        
        switch statusPlayer {
        case AVPlayer.Status.unknown:
            print("Unknown")
            break
        case AVPlayer.Status.failed:
            print("Failed")
            break
        default:
            readyToPlay()
        }
    }
    
    func readyToPlay() {
        progressIndicatorView.stopAnimating()
        progressIndicatorView.isHidden = true
        playerTapGesture = UITapGestureRecognizer(target: self, action: #selector(YTFViewController.showPlayerControls))
        playerView.addGestureRecognizer(playerTapGesture!)
        print("Ready to Play")
        self.playerView.play()
    }
    
    func playerVideo(player: PlayerView, statusItemPlayer: PVItemStatus, error: NSError?) {
    }
    
    func playerVideo(player: PlayerView, loadedTimeRanges: [PVTimeRange]) {
        if (progressIndicatorView.isHidden == false) {
            progressIndicatorView.stopAnimating()
            progressIndicatorView.isHidden = true
        }
        
        if let first = loadedTimeRanges.first {
            let bufferedSeconds = Float(CMTimeGetSeconds(first.start) + CMTimeGetSeconds(first.duration))
            progress.progress = bufferedSeconds / slider.maximumValue
        }
    }
    
    func playerVideo(player: PlayerView, duration: Double) {
        let duration = Int(duration)
        self.entireTime.text = timeFormatted(totalSeconds: duration)
        slider.maximumValue = Float(duration)
    }
    
    func playerVideo(player: PlayerView, currentTime: Double) {
        let curTime = Int(currentTime)
        self.currentTime.text = timeFormatted(totalSeconds: curTime)
        if (!dragginSlider && (Int(slider.value) != curTime)) { // Change every second
            slider.value = Float(currentTime)
        }
    }
    
    func playerVideo(player: PlayerView, rate: Float) {
        print(rate)
        if (rate == 1.0) {
            isPlaying = true
            play.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            hideTimer?.invalidate()
            showPlayerControls()
        } else {
            isPlaying = false
            play.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        }
    }
    
    func playerVideo(playerFinished player: PlayerView) {
        currentUrlIndex += 1
        playIndex(index: currentUrlIndex)
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
