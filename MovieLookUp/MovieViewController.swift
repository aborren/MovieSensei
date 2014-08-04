//
//  ViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 12/06/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

class MovieViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    // Variables
    var movie: Movie?
    var backgroundImage: UIImage?
    var api: APIController?
    var netActivityCounter = 0
    var castMembers: [Cast] = []
    
    // Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userRatingLabel : UILabel?
    @IBOutlet var userRatingBar : UIProgressView?
    @IBOutlet var backgroundView : UIImageView!
    @IBOutlet var infoTextView : UITextView!
    @IBOutlet var ratingView : UIView?
    @IBOutlet var crewCollectionView: UICollectionView?
    @IBOutlet var backDropImageView: UIImageView!
    @IBOutlet var shortInfoTextView: UITextView!
    
    // Trailer view
    @IBOutlet var trailerView: YTPlayerView!
    @IBOutlet var trailerLabel: UILabel!
    @IBOutlet var prevBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var noTrailerLabel: UILabel!
    var currentTrailer: Int = 0
    var trailerKeys: [String] = []
    
    // Table
    @IBOutlet var similarMoviesTableView: UITableView!
    var movies: [Movie] = []
    
    // layout
    @IBOutlet var similarMoviesHeightConstraint: NSLayoutConstraint!
    @IBOutlet var synopsisHeightConstraint: NSLayoutConstraint!
    func resizeInfoTextView(){
        let sizeThatShouldFitTheContent: CGSize = infoTextView.sizeThatFits(infoTextView.frame.size)
        synopsisHeightConstraint.constant = sizeThatShouldFitTheContent.height
    }
    func resizeTableView(){
        let sizeThatShouldFitTheContent: CGSize = similarMoviesTableView.sizeThatFits(similarMoviesTableView.frame.size)
        similarMoviesHeightConstraint.constant = sizeThatShouldFitTheContent.height
        
        let containerSize : CGSize = self.view.frame.size
    }
    
    //set shadow in short info view
    func setShadow(){
        shortInfoTextView.layer.shadowColor = UIColor.darkGrayColor().CGColor
        shortInfoTextView.layer.shadowOffset = CGSizeMake(1, 1)
        shortInfoTextView.layer.shadowOpacity = 1.0
        shortInfoTextView.layer.shadowRadius = 1.0
        
        titleLabel.layer.shadowColor = UIColor.darkGrayColor().CGColor
        titleLabel.layer.shadowOffset = CGSizeMake(1, 1)
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowRadius = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectionButton()
        self.api = APIController(delegate: self)
        self.title = movie!.title
        // Do any additional setup after loading the view.
        self.titleLabel.text = self.movie!.title!
        loadBackground()
        setShadow()
        
        //temp
        self.crewCollectionView!.scrollsToTop = false
        self.netActivityCounter++
        self.netActivityCounter++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      /*  self.api!.searchTMDBMovieWithID(movie!.id!)
        self.api!.searchTMDBCastWithMovieID(movie!.id!)
        self.api!.searchTMDBTrailerWithMovieID(movie!.id!)
        self.api!.searchTMDBSimilarMoviesForID(movie!.id!)*/
        self.api!.getTMDBMovieWithID_APPENDED(movie!.id!)
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
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        
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
        let context : NSManagedObjectContext = appDel.managedObjectContext!
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
        let context : NSManagedObjectContext = appDel.managedObjectContext!
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
        if(segue.identifier == "toCast"){
            var castViewController: CastViewController = segue.destinationViewController as CastViewController
            let castIndex = crewCollectionView!.indexPathForCell(sender as UICollectionViewCell).row
            var selectedCast = self.castMembers[castIndex]
            castViewController.cast = selectedCast
        }else{
            var movieViewController: MovieViewController = segue.destinationViewController as MovieViewController
            let movieIndex = similarMoviesTableView.indexPathForSelectedRow().row
            var selectedMovie = self.movies[movieIndex]
            movieViewController.movie = selectedMovie
        }
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
    
    func loadBackDrop(){
        if let url = movie!.backDrop {
            backDropImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
        }else {
            backDropImageView.image = UIImage(named: "yayoSensei2.jpg")
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
            portrait.image = UIImage(named: "profilepic.png")
        }
        
        cell.layer.cornerRadius = 5.0
        
        return cell
    }
    
    // TableView delegate functions
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if(movies.count>5){
            //seeMoreButton.hidden = false
            return 5
        }else{
            return movies.count
        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier: String = "SimilarMovieCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        let movie = self.movies[indexPath.row]
        let movieImage: UIImageView = cell.viewWithTag(800) as UIImageView
        let movieLabel: UILabel = cell.viewWithTag(830) as UILabel
        let yearLabel: UILabel = cell.viewWithTag(820) as UILabel
        
        //trim year (String in Swift is annoying atm
        /*if let date = movie.year {
        if(date != ""){
        var trimmedYear : NSString = date
        trimmedYear = trimmedYear.substringToIndex(4)
        yearLabel.text = trimmedYear
        }
        }*/
        
        movieLabel.text = movie.title
        yearLabel.text = movie.year
        movieImage.image = UIImage(named: "default.jpeg")
        if(movie.imgURL != nil){
            movieImage.sd_setImageWithURL(NSURL(string: movie.imgURL), placeholderImage: UIImage(named: "default.jpeg"))
        }
        return cell
    }
    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        if(apiType == APItype.Movie){
            processMovieData(results)
        }
        else if(apiType == APItype.RetrieveCast){
            processCastData(results)
        }
        else if(apiType == APItype.RetrieveVideos){
            processVideoData(results)
        }
        else if(apiType == APItype.RetrieveSimilar){
            processSimilarMoviesData(results)
        } else if(apiType == APItype.MovieAppendedInfo){
            processMovieData(results)
            let credits = results["credits"] as NSDictionary
            processCastData(credits)
            let videos = results["videos"] as NSDictionary
            processVideoData(videos)
            let similar = results["similar"] as NSDictionary
            processSimilarMoviesData(similar)
        }
    }
    
    func processMovieData(results: NSDictionary){
        let synopsis: String? = results["overview"] as? String
        let rating: NSNumber? = results["vote_average"] as? NSNumber
        let votes: Int? = results["vote_count"] as? Int
        let genres: NSArray? = results["genres"] as? NSArray
        let runtime: NSNumber? = results["runtime"] as? NSNumber
        let year: String? = results["release_date"] as? String
        if let genre = genres {
            for g in genre {
                self.movie!.genre.append(g["name"] as String)
            }
        }
        
        //backdrop
        let backDropURL: String? = results["backdrop_path"] as? String
        if(backDropURL != nil)
        {
            self.movie!.backDrop = "http://image.tmdb.org/t/p/w780" + backDropURL!
            loadBackDrop()
        }
        
        self.movie!.synopsis = synopsis
        self.movie!.rating = rating
        self.movie!.votes = votes
        self.movie!.runtime = runtime
        self.movie!.year = year
        if let synopsis = self.movie!.synopsis{
            self.infoTextView.text = synopsis
        }
        
        self.shortInfoTextView.text = movie!.descriptionText()
        
        resizeInfoTextView()
        
        self.netActivityCounter--
        if self.netActivityCounter == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func processCastData(results: NSDictionary){
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
    
    func processVideoData(results: NSDictionary){
        self.trailerKeys = []
        let videos: NSArray = results["results"] as NSArray
        for video in videos {
            if let videoKey = video["key"] as? String {
                trailerKeys.append(videoKey)
            }
        }
        
        updateTrailerView()
        updateButtons()
    }
    
    func processSimilarMoviesData(results: NSDictionary){
        if results.count>0 {
            //delete old movies shown
            movies = []
            let allResults: [NSDictionary] = results["results"] as [NSDictionary]
            
            // Load in result into movie datastructure
            for result: NSDictionary in allResults {
                
                let name: String? = result["title"] as? String
                var imageURL: String? = result["poster_path"] as? String
                var bgURL: String? = imageURL
                if((imageURL) != nil){
                    var url: String = imageURL!
                    imageURL = "http://image.tmdb.org/t/p/w92" + url
                    bgURL = "http://image.tmdb.org/t/p/w300" + url
                }
                let id: NSNumber? = result["id"] as? NSNumber
                let year: String? = result["release_date"] as? String
                
                let newMovie = Movie()
                newMovie.title = name
                newMovie.id = id
                newMovie.imgURL = imageURL
                newMovie.bgURL = bgURL
                newMovie.year = year
                movies.append(newMovie)
                
            }
            self.similarMoviesTableView.reloadData()
            self.similarMoviesTableView.setNeedsLayout()
            resizeTableView()
        }
    }
}
