//
//  TableViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 06/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var sugga: [SuggestedMovie] = []
    
    
    @IBOutlet var t: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //TEST EXP
        

        
        for sM in suggested {
            sugga.append(sM as SuggestedMovie)
        }
        
        //sugga.sort({$0.popularity! * $0.counter > $1.popularity! * $1.counter})
        sugga.sort({$0.rating! * $0.counter > $1.rating! * $1.counter})
        //sugga.sort({$0.counter > $1.counter})
        for sM in sugga {
            var x = sM as SuggestedMovie
            //println("\(x.title!) with rating \(x.rating!) and popularity \(x.popularity!) and counter \(x.counter)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return sugga.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("suggestedCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let movieLabel: UILabel = cell.viewWithTag(10) as UILabel
        let popularityLabel: UILabel = cell.viewWithTag(20) as UILabel
        let counterLabel: UILabel = cell.viewWithTag(30) as UILabel
        
        movieLabel.text = sugga[indexPath.row].title
        
        popularityLabel.text = sugga[indexPath.row].rating?.description
        
        counterLabel.text = sugga[indexPath.row].counter.description
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieViewController: MovieViewController = segue.destinationViewController as MovieViewController
        let movieIndex = t.indexPathForSelectedRow()!.row
        var selectedMovie = Movie()
        selectedMovie.id = sugga[movieIndex].id
        selectedMovie.title = sugga[movieIndex].title
        movieViewController.movie = selectedMovie
    }

}
