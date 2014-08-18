//
//  DiscoverViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 18/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class DiscoverGenreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, APIControllerProtocol  {

    @IBOutlet var skipButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var genreCollectionView: UICollectionView!
    var api: APIController?
    var genres = []
    var selectedGenreIDs: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.genreCollectionView.allowsMultipleSelection = true
        self.api = APIController(delegate: self)
        self.api!.getTMDBGenres()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return genres.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenreCell", forIndexPath: indexPath) as UICollectionViewCell
        (cell.viewWithTag(11) as UILabel).text = (genres[indexPath.row] as NSDictionary)["name"] as String
        return cell
    }

    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        (collectionView.cellForItemAtIndexPath(indexPath).viewWithTag(11) as UILabel).text = (genres[indexPath.row] as NSDictionary)["name"] as String + " Y "
    }
    
    func collectionView(collectionView: UICollectionView!, didDeselectItemAtIndexPath indexPath: NSIndexPath!) {
        (collectionView.cellForItemAtIndexPath(indexPath).viewWithTag(11) as UILabel).text = (genres[indexPath.row] as NSDictionary)["name"] as String
    }
    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        genres = results["genres"] as NSArray
        genreCollectionView.reloadData()
    }


    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        selectedGenreIDs = []
        for selectedGenre in genreCollectionView.indexPathsForSelectedItems() {
            selectedGenreIDs.append((genres[selectedGenre.row] as NSDictionary)["id"] as Int)
        }
        (segue.destinationViewController as DiscoverYearViewController).selectedGenreIDs = self.selectedGenreIDs
        println(selectedGenreIDs)
    }

}
