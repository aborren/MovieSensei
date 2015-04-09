//
//  CastMoreMoviesViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 27/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class CastMoreMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var appearancesTable: UITableView!
    var movies : [(movie: Movie, role: String)] = []
    var name : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = name

        var menyNavBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-25.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "toMainMenu")
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = menyNavBtn
        
    }
    
    func toMainMenu(){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView delegate functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier: String = "ApperanceCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        let movie = self.movies[indexPath.row]
        let movieImage: UIImageView = cell.viewWithTag(800) as! UIImageView
        let movieLabel: UILabel = cell.viewWithTag(810) as! UILabel
        let yearLabel: UILabel = cell.viewWithTag(820) as! UILabel
        let roleLabel: UILabel = cell.viewWithTag(830) as! UILabel
        
        movieLabel.text = movie.movie.title
        
        //trim year (String in Swift is annoying atm
        if let date = movie.movie.year {
            var trimmedYear : NSString = date
            trimmedYear = trimmedYear.substringToIndex(4)
            yearLabel.text = trimmedYear as String
        }
        
        movieImage.image = UIImage(named: "default.jpeg")
        if(movie.movie.imgURL != nil){
            movieImage.sd_setImageWithURL(NSURL(string: movie.movie.imgURL!), placeholderImage: UIImage(named: "default.jpeg"))
        }
        roleLabel.text = movie.role
        return cell
    }

    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieViewController: MovieViewController = segue.destinationViewController as! MovieViewController
        let movieIndex = appearancesTable!.indexPathForSelectedRow()!.row
        var selectedMovie = self.movies[movieIndex]
        movieViewController.movie = selectedMovie.movie
    }

}
