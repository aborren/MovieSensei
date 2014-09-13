//
//  MovieSelection.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 16/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData

@objc(MovieSelection)
class MovieSelection: NSManagedObject {
    @NSManaged var id : String
    @NSManaged var name : String
    @NSManaged var posterurl : String
    //@NSManaged var lists : NSSet
}
