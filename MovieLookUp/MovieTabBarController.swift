//
//  MovieTabBarController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 25/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData

class MovieTabBarController: UITabBarController {
    @IBOutlet var selectionButton: UIBarButtonItem?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectionButton()
        setUpViewControllers()
        self.tabBar.tintColor = UIColor(red: 236.0/255.0, green: 220.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        self.title = movie!.title
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewControllers(){
        println(self.viewControllers.count)
        var similar: SimilarMoviesViewController = self.viewControllers[2] as SimilarMoviesViewController
        similar.movie = self.movie!
        var trailers: MovieVideosViewController = self.viewControllers[1] as MovieVideosViewController
        trailers.movie = self.movie!
        var movie: MovieViewController = self.viewControllers[0] as MovieViewController
        movie.movie = self.movie!
    }
    
    @IBAction func selectionMovie(sender: AnyObject) {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        if(selectionButton!.title == "Add"){
            let entity = NSEntityDescription.entityForName("MovieSelection", inManagedObjectContext: context)
            var movieSelection = MovieSelection(entity: entity, insertIntoManagedObjectContext: context)
            //risky maybe?
            if let mov = movie {
                movieSelection.id = mov.id!.description
                movieSelection.name = mov.title!
                if let bg = mov.bgURL{
                    movieSelection.posterurl = bg
                }else{
                    movieSelection.posterurl = ""
                }
            }
            selectionButton!.title = "Remove"
        }else if(selectionButton!.title == "Remove"){
            let request = NSFetchRequest(entityName: "MovieSelection")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id = %@", movie!.id!.description)             //risky?
            var results : NSArray = context.executeFetchRequest(request, error: nil)
            if( results.count > 0){
                context.deleteObject(results[0] as NSManagedObject)
            }
            selectionButton!.title = "Add"
        }
        context.save(nil)
    }
    
    func setSelectionButton() {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "MovieSelection")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", movie!.id!.description)
        
        var results : NSArray = context.executeFetchRequest(request, error: nil)
        if( results.count > 0){
            selectionButton!.title = "Remove"
        }else{
            selectionButton!.title = "Add"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
