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
    @IBOutlet var searchResultTableView : UITableView?
    @IBOutlet var searchBar : UISearchBar?

    // Variables
    var movies: [Movie] = [Movie]()
    var api: APIController?
    var imageCache = NSMutableDictionary()
    var netActivityCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api = APIController(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.api!.searchTMDBFor(searchBar.text)
        self.view.endEditing(true)
        

    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!){
        if(searchText != ""){
            netActivityUp()
            self.api!.searchTMDBFor(searchBar.text)
        }else{
            movies = []
            self.searchResultTableView!.reloadData()
        }
    }
    
    
    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        
        var tabBar: UITabBarController = segue.destinationViewController as UITabBarController
        var movieViewController: MovieViewController = tabBar.viewControllers[0] as MovieViewController
        let movieIndex = searchResultTableView!.indexPathForSelectedRow().row
        var selectedMovie = self.movies[movieIndex]
        movieViewController.movie = selectedMovie
    }
    
    // TableView delegate functions
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier: String = "SearchResultCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        let movie = self.movies[indexPath.row]
        let movieImage: UIImageView = cell.viewWithTag(100) as UIImageView
        let movieLabel: UILabel = cell.viewWithTag(130) as UILabel
        let yearLabel: UILabel = cell.viewWithTag(120) as UILabel
        
        movieLabel.text = movie.title
        yearLabel.text = movie.year
        movieImage.image = UIImage(named: "default.jpeg")
        if(movie.imgURL != nil){
            movieImage.sd_setImageWithURL(NSURL(string: movie.imgURL), placeholderImage: UIImage(named: "default.jpeg"))
        }
        return cell
    }

    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        // Store the results in our table data array
        if results.count>0 {
            //delete old movies shown
            movies = []
            let allResults: [NSDictionary] = results["results"] as [NSDictionary]
            
            // Load in result into movie datastructure
            for result: NSDictionary in allResults {
                
                let name: String? = result["title"] as? String
                let year: String? = result["release_date"] as? String
                var imageURL: String? = result["poster_path"] as? String
                var bgURL: String? = imageURL
                if(imageURL){
                    var url: String = imageURL!
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
            self.searchResultTableView!.reloadData()
            self.searchResultTableView!.setNeedsLayout()
            netActivityDown()
        }
    }

}

