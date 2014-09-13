//
//  Lists.swift
//  MovieSensei
//
//  Created by Dan Isacson on 27/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData

@objc(Lists)
class Lists: NSManagedObject {
    @NSManaged var name : String
    @NSManaged var movies : NSSet
}
