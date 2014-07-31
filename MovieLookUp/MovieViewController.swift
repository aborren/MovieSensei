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
    @IBOutlet var backgroundView : UIImageView!
    @IBOutlet var infoTextView : UITextView!
    @IBOutlet var ratingView : UIView?
    @IBOutlet var crewCollectionView: UICollectionView?
    
    // Trailer view
    @IBOutlet var trailerView: YTPlayerView!
    @IBOutlet var trailerLabel: UILabel!
    @IBOutlet var prevBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var noTrailerLabel: UILabel!
    var currentTrailer: Int = 0
    var trailerKeys: [String] = []
    
    // layout
    @IBOutlet var synopsisHeightConstraint: NSLayoutConstraint!
    func resizeInfoTextView(){
        let sizeThatShouldFitTheContent: CGSize = infoTextView.sizeThatFits(infoTextView.frame.size)
        println(sizeThatShouldFitTheContent)
        synopsisHeightConstraint.constant = sizeThatShouldFitTheContent.height
        println(infoTextView.frame.size)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectionButton()
        self.api = APIController(delegate: self)

        // Do any additional setup after loading the view.
        self.title = movie!.title!
        loadBackground()
        
        //temp
        
        self.netActivityCounter++
        self.netActivityCounter++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api!.searchTMDBMovieWithID(movie!.id!)
        self.api!.searchTMDBCastWithMovieID(movie!.id!)
        self.api!.searchTMDBTrailerWithMovieID(movie!.id!)
        var menyNavBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-25.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "toMainMenu")
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = menyNavBtn
        
    }
    
    func toMainMenu(){
        self.navigationController.popToRootViewControllerAnimated(true)
    }

    //For core data button
    func setSelectionButton() {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "MovieSelection")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", movie!.id!.description)
        
        var results : NSArray = context.executeFetchRequest(request, error: nil)
        if( results.count > 0){
            setMinusButton()
        }else{
            setPlusButton()
        }
    }
    
    func setPlusButton(){
        var plus : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus-25.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "addMovie")
        self.navigationItem.rightBarButtonItem = plus
    }
    
    func setMinusButton(){
        var minus : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "minus-25.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "removeMovie")
        self.navigationItem.rightBarButtonItem = minus
    }
    
    func addMovie(){
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
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
        setMinusButton()
        context.save(nil)
    }
    
    func removeMovie(){
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "MovieSelection")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", movie!.id!.description)             //risky?
        var results : NSArray = context.executeFetchRequest(request, error: nil)
        if( results.count > 0){
            context.deleteObject(results[0] as NSManagedObject)
        }
        setPlusButton()
        context.save(nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //trailer
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
    
    
    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var castViewController: CastViewController = segue.destinationViewController as CastViewController
        let castIndex = crewCollectionView!.indexPathForCell(sender as UICollectionViewCell).row
        var selectedCast = self.castMembers[castIndex]
        castViewController.cast = selectedCast
    }
    
    // setup background
    func loadBackground(){
        if let url = movie!.bgURL {
            backgroundView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
            backgroundView.alpha = 0.5
        }else {
            backgroundView.image = UIImage(named: "default.jpeg")
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
            let year: String? = results["release_date"] as? String
            if let genre = genres {
                for g in genre {
                    self.movie!.genre.append(g["name"] as String)
                }
            }
            
            self.movie!.synopsis = synopsis
            self.movie!.userRating = rating
            self.movie!.runtime = runtime
            self.movie!.year = year
            self.infoTextView.text = self.movie!.descriptionText()
            resizeInfoTextView()
            
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
            self.trailerKeys = []
            let videos: NSArray? = results["results"] as? NSArray
            for video in videos! {
                trailerKeys.append(video["key"] as String)
            }
            
            updateTrailerView()
            updateButtons()
        }
    }
    
}
