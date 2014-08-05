//
//  SearchViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 12/06/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, UISearchBarDelegate {
    
    // Outlets
    @IBOutlet var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var searchResultTableView : UITableView!
    @IBOutlet var searchBar : UISearchBar!

    // Variables
    var movies: [Movie] = []
    var actors: [Cast] = []
    var api: APIController?
    var imageCache = NSMutableDictionary()
    var netActivityCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Search for movie or actor
    @IBAction func indexChanged(sender: AnyObject) {
        doSearchWithString(searchBar.text)
        self.searchResultTableView.reloadData()
        self.searchResultTableView.setNeedsLayout()
        self.searchResultTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    }
    
    //NetActivity Functions
    func netActivityUp(){
        self.netActivityCounter++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func netActivityDown(){
        self.netActivityCounter--
        if self.netActivityCounter == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // Searchbar delegate functions
    func searchBarSearchButtonClicked(searchBar: UISearchBar!){
        netActivityUp()
        doSearchWithString(searchBar.text)
        self.view.endEditing(true)
        

    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!){
        doSearchWithString(searchText)
    }
    
    func doSearchWithString(searchString:String){
        if(searchString != ""){
            // 0 = movie, 1 = actor
            if(searchTypeSegmentedControl.selectedSegmentIndex == 0){
                netActivityUp()
                self.api!.searchTMDBForMovie(searchString)
            }else if(searchTypeSegmentedControl.selectedSegmentIndex == 1){
                netActivityUp()
                self.api!.searchTMDBForPerson(searchString)
            }
        }else{
            movies = []
            actors = []
            self.searchResultTableView!.reloadData()
        }
    }
    
    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if(searchTypeSegmentedControl.selectedSegmentIndex == 0){
            var movieViewController: MovieViewController = segue.destinationViewController as MovieViewController
            let movieIndex = searchResultTableView!.indexPathForSelectedRow().row
            var selectedMovie = self.movies[movieIndex]
            movieViewController.movie = selectedMovie
        }else{
            var castViewController: CastViewController = segue.destinationViewController as CastViewController
            let castIndex = searchResultTableView!.indexPathForSelectedRow().row
            var selectedCast = self.actors[castIndex]
            castViewController.cast = selectedCast
        }
    }
    
    // TableView delegate functions
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if(searchTypeSegmentedControl.selectedSegmentIndex == 0){
            return movies.count
        }else{
            return actors.count
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if(searchTypeSegmentedControl.selectedSegmentIndex == 0){
            performSegueWithIdentifier("SearchToMovie", sender: self)
        }else{
            performSegueWithIdentifier("SearchToCast", sender: self)
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier: String = "SearchResultCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        let image: UIImageView = cell.viewWithTag(100) as UIImageView
        let nameLabel: UILabel = cell.viewWithTag(130) as UILabel
        let yearLabel: UILabel = cell.viewWithTag(120) as UILabel
        
        if(searchTypeSegmentedControl.selectedSegmentIndex == 0){
            let movie = self.movies[indexPath.row]
            //trim year (String in Swift is annoying atm
            if let date = movie.year {
                if(!date.isEmpty){
                    var trimmedYear : NSString = date
                    trimmedYear = trimmedYear.substringToIndex(4)
                    movie.year = trimmedYear
                }
            }
            nameLabel.text = movie.title
            yearLabel.text = movie.year
            image.image = UIImage(named: "default.jpeg")
            if(movie.imgURL != nil){
                image.sd_setImageWithURL(NSURL(string: movie.imgURL), placeholderImage: UIImage(named: "default.jpeg"))
            }
        }else{
            let actor = self.actors[indexPath.row]
            nameLabel.text = actor.name
            yearLabel.text = ""
            image.image = UIImage(named: "profilepic.png")
            if(actor.imageURL != nil){
                image.sd_setImageWithURL(NSURL(string: actor.imageURL), placeholderImage: UIImage(named: "default.jpeg"))
            }
        }

        return cell
    }

    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        if (apiType == APItype.SearchMovie) {
            //delete old movies shown
            movies = []
            let allResults: [NSDictionary] = results["results"] as [NSDictionary]
            
            // Load in result into movie datastructure
            for result: NSDictionary in allResults {
                
                let name: String? = result["title"] as? String
                let year: String? = result["release_date"] as? String
                var imageURL: String? = result["poster_path"] as? String
                var bgURL: String? = imageURL
                if let url = imageURL {
                    imageURL = "http://image.tmdb.org/t/p/w92" + url
                    bgURL = "http://image.tmdb.org/t/p/w300" + url
                }
                let id: NSNumber? = result["id"] as? NSNumber
                
                let newMovie = Movie()
                newMovie.title = name
                newMovie.id = id
                newMovie.imgURL = imageURL
                newMovie.bgURL = bgURL
                newMovie.year = year
                movies.append(newMovie)
            }
        }else if (apiType == APItype.SearchPerson) {
            //delete old actors shown
            actors = []
            let allResults: [NSDictionary] = results["results"] as [NSDictionary]
            
            // Load in result into cast datastructure
            for result: NSDictionary in allResults {
                
                let name: String? = result["name"] as? String
                var imageURL: String? = result["profile_path"] as? String
                let id: NSNumber? = result["id"] as? NSNumber
                
                let newActor = Cast(name: name, id: id, imageURL: imageURL)
                actors.append(newActor)
            }
        }
        self.searchResultTableView!.reloadData()
        self.searchResultTableView!.setNeedsLayout()
        netActivityDown()
    }

}

