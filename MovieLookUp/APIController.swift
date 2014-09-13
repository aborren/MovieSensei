//
//  APIController.swift
//  FirstSwiftTest
//
//  Created by Dan Isacson on 08/06/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
    func didRecieveAPIResults(results: NSDictionary, apiType: APItype)
}

class APIController {
    var delegate: APIControllerProtocol?
    
    // API KEY For Rotten Tomatoes
    //let key: NSString = "xgcfgg3pen4k6nvpq2y9haej"
    //GET config data!
    let TMDBkey: NSString = "9e4746b32f8e924b795985cc297a518f"
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    
    func searchTMDBForMovie(searchTerm: String) {
        var escapedSearchTerm = modifySearchTerm(searchTerm)
        var urlPath: String = "http://api.themoviedb.org/3/search/movie?api_key=\(TMDBkey)&query=\(escapedSearchTerm)&search_type=ngram"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.SearchMovie)
        println("Search TMDB API (movie) at URL \(url)")
        
    }
    
    func searchTMDBForPerson(searchTerm: String) {
        var escapedSearchTerm = modifySearchTerm(searchTerm)
        var urlPath: String = "http://api.themoviedb.org/3/search/person?api_key=\(TMDBkey)&query=\(escapedSearchTerm)&search_type=ngram"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.SearchPerson)
        println("Search TMDB API (person) at URL \(url)")
        
    }
    
    func searchTMDBMovieWithID(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/movie/\(escapedSearchTerm)?api_key=\(TMDBkey)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.Movie)
        println("Search TMDB movie using ID \(id) at URL \(url)")
    }
    
    func searchTMDBCastWithMovieID(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/movie/\(escapedSearchTerm)/credits?api_key=\(TMDBkey)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.RetrieveCast)
        println("Search TMDB for cast for movie with ID \(id) at URL \(url)")
    }
    
    func searchTMDBTrailerWithMovieID(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/movie/\(escapedSearchTerm)/videos?api_key=\(TMDBkey)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.RetrieveVideos)
        println("Search TMDB for trailer videos for movie with ID \(id) at URL \(url)")        
    }
    
    func searchTMDBSimilarMoviesForID(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/movie/\(escapedSearchTerm)/similar?api_key=\(TMDBkey)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.RetrieveSimilar)
        println("Search TMDB for similar movies for ID \(id) at URL \(url)")        
    }
    
    func searchTMDBNowPlaying(page: Int) {
        var urlPath = "http://api.themoviedb.org/3/movie/now_playing?api_key=\(TMDBkey)&page=\(page)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.NowPlaying)
        println("Search TMDB for Now Playing at URL \(url)")
    }
    
    func searchTMDBUpcoming(page: Int) {
        var urlPath = "http://api.themoviedb.org/3/movie/upcoming?api_key=\(TMDBkey)&page=\(page)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.Upcoming)
        println("Search TMDB for Upcoming at URL \(url)")
    }
    
    func searchTMDBPopular(page: Int) {
        var urlPath = "http://api.themoviedb.org/3/movie/popular?api_key=\(TMDBkey)&page=\(page)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.Popular)
        println("Search TMDB for Popular at URL \(url)")
    }
    
    func searchTMDBTopRated(page: Int) {
        var urlPath = "http://api.themoviedb.org/3/movie/top_rated?api_key=\(TMDBkey)&page=\(page)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.TopRated)
        println("Search TMDB for Top Rated at URL \(url)")
    }
    
    func searchTMDBPersonWithID(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/person/\(escapedSearchTerm)?api_key=\(TMDBkey)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.Person)
        println("Search TMDB person using ID \(id) at URL \(url)")
    }
    
    func searchTMDBPersonCreditWithID(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/person/\(escapedSearchTerm)/movie_credits?api_key=\(TMDBkey)"  //combined or just movie?
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.PersonAppearances)
        println("Search TMDB person's credit using ID \(id) at URL \(url)")
        
    }
    
    func getTMDBMovieWithID_APPENDED(id: NSNumber) {
        var escapedSearchTerm = modifySearchTerm(id.stringValue)
        var urlPath = "http://api.themoviedb.org/3/movie/\(escapedSearchTerm)?api_key=\(TMDBkey)&append_to_response=credits,similar,videos,images"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.MovieAppendedInfo)
        println("Getting TMDB movie using ID \(id) and appending data at URL \(url)")
    }
    
    func getTMDBGenres() {
        var urlPath = "http://api.themoviedb.org/3/genre/movie/list?api_key=\(TMDBkey)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.RetrieveGenres)
        println("Getting TMDB genres at URL \(url)")
    }
    
    func discoverTMDB(page: Int, searchString: String) {
        var urlPath = "http://api.themoviedb.org/3/discover/movie?api_key=\(TMDBkey)\(searchString)&page=\(page)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        asyncRequest(request, apiType: APItype.RetrieveDiscovery)
        println("Discovering TMDB at URL \(url)")
    }
    
    func modifySearchTerm(searchTerm: String) -> String{
        
        // The RT API wants multiple terms separated by + symbols, so replace spaces with + signs
        
        let RTSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        
        let escapedSearchTerm = RTSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        return escapedSearchTerm!
        
    }
    
    
    
    func asyncRequest(request: NSURLRequest, apiType: APItype){
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            
            if error != nil {
                
                println("ERROR: (error.localizedDescription)")
                
            }
                
            else {
                
                var error: NSError?
                
                let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                
                // Now send the JSON result to our delegate object
                
                if error != nil {
                    
                    println("HTTP Error: (error?.localizedDescription)")
                    
                }
                    
                else {
                    
                    println("Results recieved")
                    
                    self.delegate?.didRecieveAPIResults(jsonResult, apiType: apiType)
                    
                }
                
            }
            
            })
        
    }
    
    
    
}

