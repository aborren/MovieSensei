//
//  MovieVideosViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 25/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class MovieVideosViewController: UIViewController, APIControllerProtocol {

    @IBOutlet var youtubePlayer: YTPlayerView!
    
    var api: APIController?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        
        getTrailers()
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

    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        if(apiType == APItype.RetrieveVideos){
            let videos: NSArray? = results["results"] as? NSArray
            println(videos!.count)
            for video in videos! {
                self.youtubePlayer.loadWithVideoId(video["key"] as String)
                break
            }
            if(videos!.count == 0)
            {
                self.youtubePlayer.hidden = true
            }
        }
    }
}
