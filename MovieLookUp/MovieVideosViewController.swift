//
//  MovieVideosViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 25/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class MovieVideosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, APIControllerProtocol {

    //@IBOutlet var youtubePlayer: YTPlayerView!
    @IBOutlet var trailerCollectionView: UICollectionView!
    
    var api: APIController?
    var movie: Movie?
    var trailerKeys: [String] = []
    
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
    
    //CollectionView
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return trailerKeys.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("TrailerCell", forIndexPath: indexPath) as UICollectionViewCell
        let trailer: YTPlayerView = cell.viewWithTag(400) as YTPlayerView
        trailer.loadWithVideoId(trailerKeys[indexPath.row])
        cell.layer.cornerRadius = 5.0
        return cell
    }
    
  func collectionView(collectionView: UICollectionView!, didDeselectItemAtIndexPath indexPath: NSIndexPath!) {
        println("clicked")
    }
    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        self.trailerKeys = []
        if(apiType == APItype.RetrieveVideos){
            let videos: NSArray? = results["results"] as? NSArray
            println(videos!.count)
            for video in videos! {
                trailerKeys.append(video["key"] as String)
            }
            if(videos!.count == 0)
            {
                //self.youtubePlayer.hidden = true
            }
            self.trailerCollectionView.reloadData()
        }
    }
}
