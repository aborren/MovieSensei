//
//  NavigationViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 28/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Papyrus", size: 20)]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //only allow landscape for movie playback
    override func shouldAutorotate() -> Bool {
        if(self.viewControllers[self.viewControllers.count-1].isKindOfClass(YTPlayerView)){
            return true
        }
        return false
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
