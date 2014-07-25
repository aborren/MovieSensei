//
//  TopListViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 25/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class TopListViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, APIControllerProtocol {
    
    //Variables
    var movies : [Movie] = []
    var movie: Movie?
    var api: APIController?
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var MoviesCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        self.api!.searchTMDBNowPlaying()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        
        var tabBar: MovieTabBarController = segue.destinationViewController as MovieTabBarController
        var movieViewController: MovieViewController = tabBar.viewControllers[0] as MovieViewController
        let movieIndex = MoviesCollectionView!.indexPathForCell(sender as UICollectionViewCell).row
        var selectedMovie = self.movies[movieIndex]
        tabBar.movie = selectedMovie
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.api!.searchTMDBNowPlaying()
            break
        case 1:
            self.api!.searchTMDBUpcoming()
            break
        case 2:
            self.api!.searchTMDBPopular()
            break
        case 3:
            self.api!.searchTMDBTopRated()
            break
        default:
            break
        }
    }
    
    //CollectionView
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("TopListCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let movie: Movie = movies[indexPath.row]
        
        let label : UILabel = cell.viewWithTag(610) as UILabel
        let poster: UIImageView = cell.viewWithTag(600) as UIImageView
        
        if let url = movie.bgURL {
            label.text = ""
            poster.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
        }else {
            label.text = movie.title!
            poster.image = UIImage(named: "default.jpeg")
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
                movies.append(newMovie)
                
            }
            self.MoviesCollectionView!.reloadData()
            self.MoviesCollectionView!.setNeedsLayout()
        }
    }
    
}
