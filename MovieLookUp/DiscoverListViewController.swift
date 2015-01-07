//
//  DiscoverListViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 18/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class DiscoverListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, APIControllerProtocol, UIActionSheetDelegate {

    var api: APIController?
    var movies: [Movie] = []
    var selectedGenreIDs: [Int] = []
    var maxYear: Int?
    var minYear: Int?
    var page: Int = 1
    var sortByString = "&sort_by=popularity.desc"
    @IBOutlet var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        callAPI(sortByString)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNextPage(){
        page++
        if(page < 8){
            callAPI(sortByString)
        }
    }
    
    //helper to reset table
    func resetCollection(){
        movies = []
        page = 1
        moviesCollectionView!.reloadData()
        moviesCollectionView!.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    }
    
    func callAPI(sortBy: String){
        var requestString: String = "&with_genres="
        for genreID in selectedGenreIDs {
            requestString += genreID.description + ","
        }
        requestString += "&release_date.gte=\(minYear!.description)-01-01&release_date.lte=\(maxYear!.description)-12-31"
        requestString += sortBy
        self.api!.discoverTMDB(page, searchString: requestString)
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
        
        if(indexPath.row==movies.count-1){
            loadNextPage()
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let w = collectionView.frame.width / 3 - 14
        let h = w * 1.5
        return CGSize(width: w, height: h)
    }
    
    @IBAction func sortByAction(sender: AnyObject) {
        let actionSheet: UIActionSheet = UIActionSheet(title: "Sort By", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Vote Average, descending", "Vote Average, ascending", "Release Date, descending", "Release Date, ascending", "Popularity, descending", "Popularity, ascending")
        actionSheet.showInView(self.view)
    }
    
    //ActionSheet Delegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        resetCollection()
        switch buttonIndex {
        case 1:
            sortByString = "&sort_by=vote_average.desc"
            break
        case 2:
            sortByString = "&sort_by=vote_average.asc"
            break
        case 3:
            sortByString = "&sort_by=release_date.desc"
            break
        case 4:
            sortByString = "&sort_by=release_date.asc"
            break
        case 5:
            sortByString = "&sort_by=popularity.desc"
            break
        case 6:
            sortByString = "&sort_by=popularity.asc"
            break
        default:
            break
        }
        println("HELLO")
        callAPI(sortByString)
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
