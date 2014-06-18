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
    @IBOutlet var searchResultTableView : UITableView
    @IBOutlet var searchBar : UISearchBar

    // Variables
    var movies: Movie[] = Movie[]()
    var api: APIController?
    var imageCache = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api = APIController(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Searchbar delegate functions
    func searchBarSearchButtonClicked(searchBar: UISearchBar!){

        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api!.searchRTFor(searchBar.text)
        self.view.endEditing(true)
        

    }
    
    
    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var movieViewController: MovieViewController = segue.destinationViewController as MovieViewController
        let movieIndex = searchResultTableView.indexPathForSelectedRow().row
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
        cell.text = movie.title
        cell.detailTextLabel.text = movie.year
        
        let imgURLString: String? = movie.imgURL
        if let urlString = imgURLString{
            var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
        
            if( !image? ) {
                cell.image = UIImage(named: "default.jpg")
            }else{
                cell.image=image
            }
        }
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Jump in to a background thread to get the image for this item
            

            if let urlString = imgURLString{
                // Check our image cache for the existing key. This is just a dictionary of UIImages
                var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
                
                if(!image?) {
                    // If the image does not exist, we need to download it
                    var imgURL: NSURL = NSURL(string: urlString)
                    
                    // Download an NSData representation of the image at the URL
                    var request: NSURLRequest = NSURLRequest(URL: imgURL)
                    var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if !error? {
                            image = UIImage(data: data)
                            
                            // Store the image in to our cache
                            self.imageCache.setValue(image, forKey: urlString)
                            cell.image = image
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                        })
                    
                }
                else {
                    cell.image = image
                }
            }

            
            
        })
        
        tableView.indexPathForCell(cell)
        return cell
    }

    func didRecieveAPIResults(results: NSDictionary) {
        // Store the results in our table data array
        if results.count>0 {
            //delete old albums shown
            movies.removeAll(keepCapacity: true)
            let allResults: NSDictionary[] = results["movies"] as NSDictionary[]
            
            // Load in result into movie datastructure
            for result: NSDictionary in allResults {
                
                let name: String? = result["title"] as? String
                
                let year: NSNumber? = result["year"] as? NSNumber
                
                let posters: NSDictionary = result["posters"] as NSDictionary
                let imageURL: String? = posters["thumbnail"] as? String
                let bgURL: String? = posters["detailed"] as? String
                
                let id: String? = result["id"] as? String

                let newMovie: Movie = Movie(title: name, year: year, id: id, imgURL: imageURL, bgURL: bgURL)
                movies.append(newMovie)
                
            }
            self.searchResultTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }

}

