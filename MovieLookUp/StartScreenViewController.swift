//
//  StartScreenViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 13/09/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    @IBOutlet var blinkingSensei: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        url = [[NSBundle mainBundle] URLForResource:@"variableDuration" withExtension:@"gif"];
        self.variableDurationImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];*/
        let url = NSBundle.mainBundle().URLForResource("blink_new", withExtension: "gif")
        self.blinkingSensei.image = UIImage.animatedImageWithAnimatedGIFURL(url)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
