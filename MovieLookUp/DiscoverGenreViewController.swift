//
//  DiscoverViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 18/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class DiscoverGenreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, APIControllerProtocol  {

    @IBOutlet var genreCollectionView: UICollectionView!
    var api: APIController?
    var genres: NSMutableArray = []
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
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return genres.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenreCell", forIndexPath: indexPath) as! UICollectionViewCell
        (cell.viewWithTag(11) as! UILabel).text = (genres[indexPath.row] as! NSDictionary)["name"] as? String
        
        
        updateSelectedRows()
        cell.backgroundColor = UIColor.whiteColor()
        for id in selectedGenreIDs{
            if((genres[indexPath.row] as! NSDictionary)["id"] as! Int == id){
                cell.backgroundColor = UIColor.lightGrayColor()
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)!.backgroundColor = UIColor.lightGrayColor()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)!.backgroundColor = UIColor.whiteColor()
    }
    
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype) {
        genres = results["genres"] as! NSMutableArray
        for genre in genres {
            if(((genre as! NSDictionary)["name"] as! String!) == "Erotic"){
                genres.removeObject(genre)
            }
        }
        genreCollectionView.reloadData()
    }

    func updateSelectedRows(){
        selectedGenreIDs = []
        for selectedGenre in genreCollectionView.indexPathsForSelectedItems() {
            selectedGenreIDs.append((genres[selectedGenre.row] as! NSDictionary)["id"] as! Int)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width/2 - 15), height: 50)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        updateSelectedRows()
        (segue.destinationViewController as! DiscoverYearViewController).selectedGenreIDs = self.selectedGenreIDs
        println(selectedGenreIDs)
    }

}
