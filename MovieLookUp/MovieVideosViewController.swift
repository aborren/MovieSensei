//
//  MovieVideosViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 25/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class MovieVideosViewController: UIViewController, APIControllerProtocol {

    //@IBOutlet var youtubePlayer: YTPlayerView!
    @IBOutlet var background: UIImageView!
    @IBOutlet var trailerView: YTPlayerView!
    @IBOutlet var trailerLabel: UILabel!
    @IBOutlet var prevBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var noTrailerLabel: UILabel!
    
    var api: APIController?
    var movie: Movie?
    var currentTrailer: Int = 0
    var trailerKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        getTrailers()
        loadBackground()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //set up youtube
    func getTrailers(){
        self.api!.searchTMDBTrailerWithMovieID(movie!.id!)
    }
    
    //IBActions
    @IBAction func prevClick(sender: AnyObject) {
        currentTrailer--
        updateTrailerView()
        updateButtons()
    }
    @IBAction func nextClick(sender: AnyObject) {
        currentTrailer++
        updateTrailerView()
        updateButtons()
    }
    
    func updateButtons(){
        nextBtn.hidden = false
        prevBtn.hidden = false
        if(trailerKeys.count == 0){
            nextBtn.hidden = true
            prevBtn.hidden = true
        }
        if(currentTrailer == 0){
            prevBtn.hidden = true
        }
        if(currentTrailer == trailerKeys.count-1){
            nextBtn.hidden = true
        }
    }
    
    func loadBackground(){
        if let url = movie!.bgURL {
            background.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
            background.alpha = 0.5
        }else {
            background.image = UIImage(named: "default.jpeg")
        }
    }
    
    func updateTrailerView(){
        if (trailerKeys.count > 0){
            var tracker: String
            tracker = "\(currentTrailer+1)/\(trailerKeys.count)"
            trailerLabel.text = tracker
            trailerView.loadWithVideoId(trailerKeys[currentTrailer])
        } else {
            noTrailerLabel.hidden = false
        }
    }

    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        self.trailerKeys = []
        if(apiType == APItype.RetrieveVideos){
            let videos: NSArray? = results["results"] as? NSArray
            for video in videos! {
                trailerKeys.append(video["key"] as String)
            }
            
            updateTrailerView()
            updateButtons()
        }
    }
}
