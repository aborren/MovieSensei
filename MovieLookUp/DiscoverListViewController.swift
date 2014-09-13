//
//  DiscoverListViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 18/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class DiscoverListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, APIControllerProtocol {

    var api: APIController?
    var movies: [Movie] = []
    var selectedGenreIDs: [Int] = []
    var maxYear: Int?
    var minYear: Int?
    @IBOutlet var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        callAPI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callAPI(){
        var requestString: String = "&with_genres="
        for genreID in selectedGenreIDs {
            requestString += genreID.description + ","
        }
        requestString += "&release_date.gte=\(minYear!.description)-01-01&release_date.lte=\(maxYear!.description)-12-31"
        requestString += "&sort_by=popularity.desc"
        self.api!.discoverTMDB(1, searchString: requestString)
    }

    //CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return movies.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("DiscoverMovieCell", forIndexPath: indexPath) as UICollectionViewCell
        let movie: Movie = movies[indexPath.row] as Movie
        //let label : UILabel = cell.viewWithTag(610) as UILabel
        let poster: UIImageView = cell.viewWithTag(600) as UIImageView
        if let url = movie.bgURL {
            //label.text = ""
            poster.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
        }else {
            //label.text = movie.title!
            //label.transform = CGAffineTransformMakeRotation( 3.14 / 3.0 )
            poster.image = UIImage(named: "default.jpeg")
        }
        //load more data
        /*
        if(indexPath.row==movies.count-1){
            loadNextPage()
        }*/
        return cell
    }
    
    //API
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        // Store the results in our table data array
        if results.count>0 {
            //delete old movies shown
            //movies = []
            let allResults: [NSDictionary] = results["results"] as [NSDictionary]
            // Load in result into movie datastructure
            for result: NSDictionary in allResults {
                let name: String? = result["title"] as? String
                var imageURL: String? = result["poster_path"] as? String
                var bgURL: String? = imageURL
                if(imageURL != nil){
                    var url: String = imageURL!
                    imageURL = "http://image.tmdb.org/t/p/w92" + url
                    bgURL = "http://image.tmdb.org/t/p/w300" + url
                }else{
                    continue
                }
                let id: NSNumber? = result["id"] as? NSNumber
                let newMovie = Movie()
                newMovie.title = name
                newMovie.id = id
                newMovie.imgURL = imageURL
                newMovie.bgURL = bgURL
                movies.append(newMovie)
            }
            self.moviesCollectionView!.reloadData()
            self.moviesCollectionView!.setNeedsLayout()
            if(movies.count==0){
                self.title = "No results"
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieViewController: MovieViewController = segue.destinationViewController as MovieViewController
        let sendingCell: UICollectionViewCell = sender as UICollectionViewCell
        let movieIndex = moviesCollectionView!.indexPathForCell(sendingCell)!.row
        var selectedMovie = self.movies[movieIndex]
        movieViewController.movie = selectedMovie
        
    }

}
