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
    @IBOutlet var criticsRatingLabel : UILabel
    @IBOutlet var userRatingBar : UIProgressView
    @IBOutlet var criticRatingBar : UIProgressView
    @IBOutlet var backgroundView : UIImageView
    @IBOutlet var infoTextView : UITextView
    @IBOutlet var ratingView : UIView
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.netActivityCounter++
        loadBackground()
        roundCorners()
        
        self.api = APIController(delegate: self)
        
        self.netActivityCounter++
        self.api!.searchRTMovieWithID(movie!.id!)
        
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
            userRatingLabel.text = "User rating: \(userR)%"
            if userR == -1 {
                userRatingLabel.text = "User rating: none"
            }
        }
        
        if let critR = self.movie!.criticsRating{
            criticsRatingLabel.text = "Critics rating: \(critR)%"
            if critR == -1 {
                criticsRatingLabel.text = "Critics rating: none"
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
        
        if let rating = movie?.criticsRatingAsFloat(){
            if rating > 0.7{
                self.criticRatingBar.tintColor = UIColor.greenColor()
            }else if rating > 0.5 {
                self.criticRatingBar.tintColor = UIColor.yellowColor()
            }else {
                self.criticRatingBar.tintColor = UIColor.redColor()
            }
            self.criticRatingBar.progress = rating
            println(rating)
        }
        else{
            self.criticRatingBar.hidden = true
        }
        
    }
    
    // setup background
    func loadBackground(){
        let imgURLString = movie!.bgURL
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if let urlString = imgURLString{
                    var imgURL: NSURL = NSURL(string: urlString)
                    
                    // Download an NSData representation of the image at the URL
                    var request: NSURLRequest = NSURLRequest(URL: imgURL)
                    var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)
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
    
    func didRecieveAPIResults(results: NSDictionary) {
        let runtime: NSNumber? = results["runtime"] as? NSNumber
        let synopsis: String? = results["synopsis"] as? String
        let genre: String[]? = results["genres"] as? String[]

        let userRating: NSNumber? = results["ratings"].valueForKey("audience_score") as? NSNumber
        let criticsRating: NSNumber? = results["ratings"].valueForKey("critics_score") as? NSNumber
        self.movie!.setMoreInfo(runtime, synopsis: synopsis, genre: genre, userRating: userRating!, criticsRating: criticsRating!)
        
        
        self.infoTextView.text = self.movie!.descriptionText()
        writeRatings()

        
        self.netActivityCounter--
        if self.netActivityCounter == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
}
