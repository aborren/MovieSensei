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
    //GET config data!
    let TMDBkey: NSString = "9e4746b32f8e924b795985cc297a518f"
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    
    func searchTMDBFor(searchTerm: String) {
        var escapedSearchTerm = modifySearchTerm(searchTerm)
        var urlPath: String = "http://api.themoviedb.org/3/search/movie?api_key=\(TMDBkey)&query=\(escapedSearchTerm)&search_type=ngram"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        
        asyncRequest(request)
        
        println("Search TMDB API (movie) at URL \(url)")
    }
    
    func searchTMDBMovieWithID(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/movie/\(escapedSearchTerm)?api_key=\(TMDBkey)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request)
        
        println("Search TMDB movie using ID \(id) at URL \(url)")
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
