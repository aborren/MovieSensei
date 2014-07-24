//
//  Cast.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 16/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import Foundation

class Cast{
    let name: NSString?
    let id: NSNumber?
    let imageURL: NSString?
    let character: NSString?
    
    init(){
        
    }
    
    init(name: NSString?, id: NSNumber?, imageURL: NSString?, character: NSString?){
        self.name = name
        self.id = id
        if let url = imageURL {
            self.imageURL = "http://image.tmdb.org/t/p/w92" + url
        }
        self.character = character
    }
}