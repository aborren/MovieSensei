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
    var movies : [Movie] = []
    var roles : [String]  = []
    var name : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView delegate functions
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier: String = "ApperanceCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        let movie = self.movies[indexPath.row]
        let role = self.roles[indexPath.row]
        let movieImage: UIImageView = cell.viewWithTag(800) as UIImageView
        let movieLabel: UILabel = cell.viewWithTag(810) as UILabel
        let yearLabel: UILabel = cell.viewWithTag(820) as UILabel
        let roleLabel: UILabel = cell.viewWithTag(830) as UILabel
        
        movieLabel.text = movie.title
        
        //trim year (String in Swift is annoying atm
        if let date = movie.year {
            var trimmedYear : NSString = date
            trimmedYear = trimmedYear.substringToIndex(4)
            yearLabel.text = trimmedYear
        }
        
        movieImage.image = UIImage(named: "default.jpeg")
        if(movie.imgURL != nil){
            movieImage.sd_setImageWithURL(NSURL(string: movie.imgURL), placeholderImage: UIImage(named: "default.jpeg"))
        }
        roleLabel.text = role
        return cell
    }

    // send new data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var tabBar: MovieTabBarController = segue.destinationViewController as MovieTabBarController
        var movieViewController: MovieViewController = tabBar.viewControllers[0] as MovieViewController
        let movieIndex = appearancesTable!.indexPathForSelectedRow().row
        var selectedMovie = self.movies[movieIndex]
        tabBar.movie = selectedMovie
    }

}
