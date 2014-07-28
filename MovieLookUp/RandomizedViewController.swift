//
//  RandomizedViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 28/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import QuartzCore

class RandomizedViewController: UIViewController {

    var movie : Movie?
    
    @IBOutlet var poster: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mov = movie{
            if let url = mov.bgURL {
                poster.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
                var anime = CABasicAnimation(keyPath: "transform.scale")
                anime.fromValue = 2.0
                anime.toValue = 1
                anime.duration = 0.4
                anime.removedOnCompletion = false
                anime.fillMode = kCAFillModeForwards
                poster.layer.addAnimation(anime, forKey: "scale")
            
            }else {
                poster.image = UIImage(named: "default.jpeg")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leave(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
