//
//  ViewController.swift
//  YoutubeFloatingPlayer
//
//  Created by Gook whan Ahn on 2021/10/04.
//

import UIKit

class ViewController: UIViewController {

    
    let videos = [Video.init(name: "Big Bunny", artist: "Google", url: NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!),
                  Video.init(name: "Robo Toy", artist: "Google", url: NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")!),
                  Video.init(name: "Big Bunny", artist: "Google", url: NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!),
                  Video.init(name: "Robo Toy", artist: "Google", url: NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")!),
                  Video.init(name: "Big Bunny", artist: "Google", url: NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!),
                  Video.init(name: "Robo Toy", artist: "Google", url: NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")!),
                  Video.init(name: "Big Bunny", artist: "Google", url: NSURL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!),
                  Video.init(name: "Robo Toy", artist: "Google", url: NSURL(string: "http://techslides.com/demos/sample-videos/small.mp4")!)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBAction func showPlayer(sender: AnyObject) {
        var urls: [NSURL] = []
        for video in videos {
            urls.append(video.url)
        }
        YTFPlayer.initYTF(urls:urls, tableCellNibName: "VideoCell", delegate: self, dataSource: self)
        YTFPlayer.showYTFView(viewController:self)
    }
    
}

//MARK: YTFTableView

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath as IndexPath) as! VideoCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath as IndexPath) as! VideoCell
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! VideoCell
        cell.labelArtist.text = videos[indexPath.row].artist
        cell.labelTitle.text = videos[indexPath.row].name
        if (indexPath.row % 2 == 0) {
            cell.imageThumbnail.image = UIImage(named: "bigBunny")
        } else {
            cell.imageThumbnail.image = UIImage(named: "legoToy")
        }
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        YTFPlayer.playIndex(index: indexPath.row)
    }
}
