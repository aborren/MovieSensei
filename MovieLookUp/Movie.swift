//
//  Movie.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 12/06/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import Foundation

class Movie {
    var title: String?
    var year: String?
    var id: NSNumber?
    var imgURL: String?
    var bgURL: String?
    
    // load this data from another call
    var runtime: NSNumber?
    var synopsis: String?
    var genre: [String] = []
    var userRating: NSNumber?
    
    //for random selection
    var selected: Bool = false
    // Maybe acters?
    
    
    init()
    {
        
    }
    
    init(title: String?, year: NSNumber?, id:NSNumber?, imgURL:String?, bgURL:String?){
        self.title = title
        var nf: NSNumberFormatter = NSNumberFormatter()
        self.year = nf.stringFromNumber(year)
        self.id = id
        self.imgURL = imgURL
        self.bgURL = bgURL
    }
    
    func setMoreInfo(runtime: NSNumber?, synopsis: String?, genre: [String], userRating: NSNumber){
        self.runtime = runtime
        self.synopsis = synopsis
        self.genre = genre
        self.userRating = userRating
    }
    
    func descriptionText()->String{
        var description: String = ""

        if let year = self.year{
            description += "Released: \(year)\n"
        }
        
        if let runtime = self.runtime {
            description += "Runtime: \(runtime) min\n"
        }
        
        if let rating = self.userRatingAsFloat() {
            let rate = NSString(format: "%.1f", rating)
            description += "Rating: \(rate)\n"
        }
        
        description += "Genre: "
        for (var i = 0; i < genre.count; ++i) {
            description += genre[i]
            if(i+1 < genre.count){
                description += ", "
            }
        }
        description += "\n"
        
        if let synopsis = self.synopsis {
            if synopsis != ""{description += "\nSynopsis:\n\(synopsis)\n"}
        }
        
        return description
    }
    
    func userRatingAsFloat()->Float?{
        if let rating = self.userRating{
            return rating.floatValue
        }
        return nil
    }
}