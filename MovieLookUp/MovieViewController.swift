//
//  ViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 12/06/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData

class MovieViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, APIControllerProtocol {
    // Variables
    var movie: Movie?
    var backgroundImage: UIImage?
    var api: APIController?
    var netActivityCounter = 0
    var castMembers: [Cast] = []
    
    // Outlets
    @IBOutlet var userRatingLabel : UILabel?
    @IBOutlet var userRatingBar : UIProgressView?
    @IBOutlet var backgroundView : UIImageView?
    @IBOutlet var infoTextView : UITextView?
    @IBOutlet var ratingView : UIView?
    @IBOutlet var crewCollectionView: UICollectionView?
    @IBOutlet var selectionButton: UIBarButtonItem?
    @IBOutlet var youtubePlayer: YTPlayerView!
    
    @IBAction func selectionMovie(sender: AnyObject) {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        if(selectionButton!.title == "Add"){
            let entity = NSEntityDescription.entityForName("MovieSelection", inManagedObjectContext: context)
            var movieSelection = MovieSelection(entity: entity, insertIntoManagedObjectContext: context)
            //risky maybe?
            if let mov = movie {
                movieSelection.id = mov.id!.description
                movieSelection.name = mov.title!
                if let bg = mov.bgURL{
                    movieSelection.posterurl = bg
                }else{
                    movieSelection.posterurl = ""
                }
            }
            selectionButton!.title = "Remove"
        }else if(selectionButton!.title == "Remove"){
            let request = NSFetchRequest(entityName: "MovieSelection")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id = %@", movie!.id!.description)             //risky?
            var results : NSArray = context.executeFetchRequest(request, error: nil)
            if( results.count > 0){
                context.deleteObject(results[0] as NSManagedObject)
            }
            selectionButton!.title = "Add"
        }
        context.save(nil)
    }
    
    func setSelectionButton() {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "MovieSelection")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", movie!.id!.description)
        
        var results : NSArray = context.executeFetchRequest(request, error: nil)
        if( results.count > 0){
            selectionButton!.title = "Remove"
        }else{
            selectionButton!.title = "Add"
        }
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movie?.title
        self.api = APIController(delegate: self)

        // Do any additional setup after loading the view.
        setSelectionButton()
        loadBackground()
        getTrailers()
        
        //temp
        
        self.netActivityCounter++
        self.netActivityCounter++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api!.searchTMDBMovieWithID(movie!.id!)
        self.api!.searchTMDBCastWithMovieID(movie!.id!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var castViewController: CastViewController = segue.destinationViewController as CastViewController
        let castIndex = crewCollectionView!.indexPathForCell(sender as UICollectionViewCell).row
        var selectedCast = self.castMembers[castIndex]
        castViewController.cast = selectedCast
    }
  /*
    // set up ratingView not used anymore..
   func writeRatings(){
        if let userR = self.movie!.userRating{
            userRatingLabel.text = "Rating: \(userR)"
            if userR == -1 {
                userRatingLabel.text = "Rating: none"
            }
        }
        
        if let rating = movie?.userRatingAsFloat() {
            if rating > 0.7{
                self.userRatingBar.tintColor = UIColor.greenColor()
            }else if rating > 0.5 {
                self.userRatingBar.tintColor = UIColor.yellowColor()
            }else {
                self.userRatingBar.tintColor = UIColor.redColor()
            }
            self.userRatingBar.progress = rating
            println(rating)
        }
        else{
            self.userRatingBar.hidden = true
        }
        
    }*/
    
    //set up youtube
    func getTrailers(){
        self.netActivityCounter++
        self.api!.searchTMDBTrailerWithMovieID(movie!.id!)
    }
    
    // setup background
    func loadBackground(){
        let imgURLString = movie!.bgURL
        if(movie!.bgURL != nil){
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let urlString = imgURLString{
                        var imgURL: NSURL = NSURL(string: urlString)
                    
                        // Download an NSData representation of the image at the URL
                        var request: NSURLRequest = NSURLRequest(URL: imgURL)
                        var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)
                        self.netActivityCounter++
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                            if !error? {
                                self.backgroundImage = UIImage(data: data)

                                self.backgroundView!.image = self.backgroundImage
                                self.backgroundView!.alpha = 0.5
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                            self.netActivityCounter--
                            if self.netActivityCounter == 0 {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            }
                        })
                }
            })
        }
    }
    
    //CollectionView
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return castMembers.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CrewCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let cast: Cast = castMembers[indexPath.row]
        
        let portrait: UIImageView = cell.viewWithTag(200) as UIImageView
        let name: UILabel = cell.viewWithTag(210) as UILabel
        let character: UILabel = cell.viewWithTag(220) as UILabel
        
        name.text = cast.name
        character.text = cast.character
        
        if let url = cast.imageURL {
            portrait.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
        }else {
            portrait.image = UIImage(named: "default.jpeg")
        }
        
        cell.layer.cornerRadius = 5.0
        
        return cell
    }
    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        if(apiType == APItype.Movie){
            let synopsis: String? = results["overview"] as? String
            let rating: NSNumber? = results["vote_average"] as? NSNumber
            let genres: NSArray? = results["genres"] as? NSArray
            let runtime: NSNumber? = results["runtime"] as? NSNumber
            for genre in genres! {
                self.movie!.genre.append(genre["name"] as String)
            }
            
            self.movie!.synopsis = synopsis
            self.movie!.userRating = rating
            self.movie!.runtime = runtime
            self.infoTextView!.text = self.movie!.descriptionText()
            
            self.netActivityCounter--
            if self.netActivityCounter == 0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
        else if(apiType == APItype.RetrieveCast){
            let cast: NSArray? = results["cast"] as? NSArray
            for person in cast! {
                self.castMembers.append(Cast(name: person["name"] as? NSString, id: person["id"] as? NSNumber, imageURL: person["profile_path"] as? NSString, character: person["character"] as? NSString))
            }
            self.netActivityCounter--
            if self.netActivityCounter == 0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            self.crewCollectionView!.reloadData()
            self.crewCollectionView!.setNeedsLayout()
        }
        else if(apiType == APItype.RetrieveVideos){
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
            self.netActivityCounter--
            if self.netActivityCounter == 0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

        }
    }
    
}
