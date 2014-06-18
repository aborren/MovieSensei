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
    var id: String?
    var imgURL: String?
    var bgURL: String?
    
    // load this data from another call
    var runtime: NSNumber?
    var synopsis: String?
    var genre: String[]?
    var userRating: NSNumber?
    var criticsRating: NSNumber?
    
    var selected: Bool = false
    // Maybe acters?
    
    
    init(title: String?, year: NSNumber?, id:String?, imgURL:String?, bgURL:String?){
        self.title = title
        var nf: NSNumberFormatter = NSNumberFormatter()
        self.year = nf.stringFromNumber(year)
        self.id = id
        self.imgURL = imgURL
        self.bgURL = bgURL
    }
    
    func setMoreInfo(runtime: NSNumber?, synopsis: String?, genre: String[]?, userRating: NSNumber, criticsRating: NSNumber){
        self.runtime = runtime
        self.synopsis = synopsis
        self.genre = genre
        self.userRating = userRating
        self.criticsRating = criticsRating
    }
    
    func descriptionText()->String{
        var description: String = ""
        
        if let title = self.title{
           description += title + "\n\n"
        }
        
        if let year = self.year{
            description += "Year: \(year)\n"
        }
        
        if let runtime = self.runtime {
            description += "Runtime: \(runtime) min\n"
        }
        
        if let genre = self.genre {
            description += "\nGenre:\n"
            for (var i = 0; i < genre.count; ++i) {
                description += genre[i] + "\n"
            }
        }
        

        
        if let synopsis = self.synopsis {
            if synopsis != ""{description += "\nSynopsis:\n\(synopsis)\n"}
        }
        
        return description
    }
    
    func userRatingAsFloat()->Float?{
        if let rating = self.userRating{
            return rating.floatValue/100.0
        }
        return nil
    }
    
    func criticsRatingAsFloat()->Float?{
        if let rating = self.criticsRating{
            return rating.floatValue/100.0
        }
        return nil
    }
}