//
//  APIController.swift
//  FirstSwiftTest
//
//  Created by Dan Isacson on 08/06/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
    func didRecieveAPIResults(results: NSDictionary)
}
class APIController {
    var delegate: APIControllerProtocol?
    // API KEY For Rotten Tomatoes
    let key: NSString = "xgcfgg3pen4k6nvpq2y9haej"
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    
    func searchRTFor(searchTerm: String) {
        var escapedSearchTerm = modifySearchTerm(searchTerm)
        var urlPath = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=\(key)&q=\(escapedSearchTerm)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        
        asyncRequest(request)

        println("Search RT API (movie) at URL \(url)")
    }
    
    func searchRTMovieWithID(id: String) {
        var escapedSearchTerm = modifySearchTerm(id)
        var urlPath = "http://api.rottentomatoes.com/api/public/v1.0/movies/\(escapedSearchTerm).json?apikey=\(key)"

        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        
        asyncRequest(request)
        
        println("Search RT movie using ID \(id) at URL \(url)")
    }
    
    func modifySearchTerm(searchTerm: String) -> String{
        // The RT API wants multiple terms separated by + symbols, so replace spaces with + signs
        let RTSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        // Now escape anything else that isn't URL-friendly
        let escapedSearchTerm = RTSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return escapedSearchTerm
    }
    
    func asyncRequest(request: NSURLRequest){
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error? {
                println("ERROR: (error.localizedDescription)")
            }
            else {
                var error: NSError?
                let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                // Now send the JSON result to our delegate object
                if error? {
                    println("HTTP Error: (error?.localizedDescription)")
                }
                else {
                    println("Results recieved")
                    self.delegate?.didRecieveAPIResults(jsonResult)
                }
            }
            })
    }

}
