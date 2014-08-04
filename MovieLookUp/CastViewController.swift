//
//  CastContainerViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 27/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class CastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var cast : Cast?
    var api : APIController?
    var movies : [(movie: Movie, role: String)] = []
    
    
    @IBOutlet var appearancesTable: UITableView!
    @IBOutlet var portrait: UIImageView!
    @IBOutlet var biography: UITextView!
    @IBOutlet var basicInfo: UIView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var bornLabel: UILabel!
    @IBOutlet var diedLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    
    @IBOutlet var seeMoreButton: UIButton!
    
    @IBOutlet var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet var biographyHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        showNameAndPortrait()
        callApi()
        
        var menyNavBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-25.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "toMainMenu")
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = menyNavBtn
        
    }
    
    func toMainMenu(){
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNameAndPortrait(){
        if let cast = self.cast {
            self.title = cast.name
            nameLabel.text = cast.name
            if let url = cast.imageURL {
                portrait.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
            }else {
                portrait.image = UIImage(named: "profilepic.png")
            }
        }
    }
    
    func callApi(){
        self.api!.searchTMDBPersonWithID(cast!.id!)
        self.api!.searchTMDBPersonCreditWithID(cast!.id!)
    }
    
    func resizeBiographyTextView(){
        let sizeThatShouldFitTheContent: CGSize = biography.sizeThatFits(biography.frame.size)
        biographyHeightConstraint.constant = sizeThatShouldFitTheContent.height
    }
    
    func resizeTableView(){
        let sizeThatShouldFitTheContent: CGSize = appearancesTable.sizeThatFits(appearancesTable.frame.size)
        tableHeightConstraint.constant = sizeThatShouldFitTheContent.height
        
        let containerSize : CGSize = self.view.frame.size
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    // TableView delegate functions
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if(movies.count>5){
            seeMoreButton.hidden = false
            return 5
        }else{
            return movies.count
        }
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier: String = "ApperanceCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        let movie = self.movies[indexPath.row]
        let movieImage: UIImageView = cell.viewWithTag(700) as UIImageView
        let movieLabel: UILabel = cell.viewWithTag(710) as UILabel
        let yearLabel: UILabel = cell.viewWithTag(720) as UILabel
        let roleLabel: UILabel = cell.viewWithTag(730) as UILabel
        
        movieLabel.text = movie.movie.title
        
        //trim year (String in Swift is annoying atm
        if let date = movie.movie.year {
            var trimmedYear : NSString = date
            trimmedYear = trimmedYear.substringToIndex(4)
            yearLabel.text = trimmedYear
        }
        
        movieImage.image = UIImage(named: "default.jpeg")
        if(movie.movie.imgURL != nil){
            movieImage.sd_setImageWithURL(NSURL(string: movie.movie.imgURL), placeholderImage: UIImage(named: "default.jpeg"))
        }
        roleLabel.text = movie.role
        return cell
    }
    
    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if (segue.identifier == "MoreMovies"){
            var moreMoviesViewController: CastMoreMoviesViewController = segue.destinationViewController as CastMoreMoviesViewController
            moreMoviesViewController.movies = self.movies
            if let name = self.cast?.name{
                moreMoviesViewController.name = name
            }
        }else{
            var movieViewController: MovieViewController = segue.destinationViewController as MovieViewController
            let movieIndex = appearancesTable!.indexPathForSelectedRow().row
            var selectedMovie = self.movies[movieIndex]
            movieViewController.movie = selectedMovie.movie
        }
    }
    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        if(apiType == APItype.PersonAppearances && results.count>0 ){
            //delete old movies shown
            movies = []
            let allResults: [NSDictionary] = results["cast"] as [NSDictionary]
            // Load in result into movie datastructure
            for result: NSDictionary in allResults {
                
                let name: String? = result["title"] as? String
                var imageURL: String? = result["poster_path"] as? String
                var bgURL: String? = imageURL
                if let url = imageURL {
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
                if(newMovie.title != nil && newMovie.title != ""){
                    movies.append(movie: newMovie, role: result["character"] as String)
                }
                
            }
            //sort movies!
            movies.sort({$0.movie.year > $1.movie.year})
            
            self.appearancesTable!.reloadData()
            self.appearancesTable!.setNeedsLayout()
            resizeTableView()
        }else if(apiType == APItype.Person && results.count>0 ){
            biography.text = results["biography"] as? String
            resizeBiographyTextView()
            
            if let born = results["birthday"] as? String {
                if(born != ""){
                    bornLabel.text = "Born: \(born)"
                }
            }
            if let died = results["deathday"] as? String {
                if(died != ""){
                    diedLabel.text = "Died: \(died)"
                }
            }
            if let from = results["place_of_birth"] as? String {
                if(from != ""){
                    fromLabel.text = "From: \(from)"
                }
            }
        }
        
    }
    
}
