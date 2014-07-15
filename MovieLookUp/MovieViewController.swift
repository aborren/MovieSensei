//
//  ViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 12/06/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, APIControllerProtocol {
    // Variables
    var movie: Movie?
    var backgroundImage: UIImage?
    var api: APIController?
    var netActivityCounter = 0
    
    // Outlets
    @IBOutlet var userRatingLabel : UILabel
    @IBOutlet var userRatingBar : UIProgressView
    @IBOutlet var backgroundView : UIImageView
    @IBOutlet var infoTextView : UITextView
    @IBOutlet var ratingView : UIView
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadBackground()
        roundCorners()
        
        self.api = APIController(delegate: self)
        
        //temp
        
        self.netActivityCounter++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api!.searchTMDBMovieWithID(movie!.id!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // design view
    func roundCorners(){
        infoTextView.layer.cornerRadius = 5.0
        ratingView.layer.cornerRadius = 5.0
    }
    
    // set up ratingView
   func writeRatings(){
        if let userR = self.movie!.userRating{
            userRatingLabel.text = "Rating: \(userR)"
            if userR == -1 {
                userRatingLabel.text = "Rating: none"
            }
        }
        
        if let rating = movie?.userRatingAsFloat() {
            if rating > 0.7{
                self.userRatingBar.tintColor = UIColor.greenColor()
            }else if rating > 0.5 {
                self.userRatingBar.tintColor = UIColor.yellowColor()
            }else {
                self.userRatingBar.tintColor = UIColor.redColor()
            }
            self.userRatingBar.progress = rating
            println(rating)
        }
        else{
            self.userRatingBar.hidden = true
        }
        
    }
    
    // setup background
    func loadBackground(){
        let imgURLString = movie!.bgURL
        if(movie!.bgURL != nil){
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let urlString = imgURLString{
                        var imgURL: NSURL = NSURL(string: urlString)
                    
                        // Download an NSData representation of the image at the URL
                        var request: NSURLRequest = NSURLRequest(URL: imgURL)
                        var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)
                        self.netActivityCounter++
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                            if !error? {
                                self.backgroundImage = UIImage(data: data)

                                self.backgroundView.image = self.backgroundImage
                                self.backgroundView.alpha = 0.5
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                            self.netActivityCounter--
                            if self.netActivityCounter == 0 {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            }
                        })
                }
            })
        }
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        let synopsis: String? = results["overview"] as? String
        let rating: NSNumber? = results["vote_average"] as? NSNumber
        let genres: NSArray? = results["genres"] as? NSArray
        let runtime: NSNumber? = results["runtime"] as? NSNumber
        for genre in genres! {
            println(genre["name"])
            self.movie!.genre.append(genre["name"] as String)
        }
        
        self.movie!.synopsis = synopsis
        self.movie!.userRating = rating
        self.movie!.runtime = runtime
        self.infoTextView.text = self.movie!.descriptionText()
        writeRatings()

        
        self.netActivityCounter--
        if self.netActivityCounter == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
}
