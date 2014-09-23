//
//  InformationViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 23/09/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToFacebook(sender: AnyObject) {
        let url = NSURL(string: "fb://profile/356517281166111")
        UIApplication.sharedApplication().openURL(url)
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
