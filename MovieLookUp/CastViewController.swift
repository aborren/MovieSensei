//
//  CastViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 16/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class CastViewController: UIViewController {
    
    var cast: Cast?
    @IBOutlet var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cast?.name
        // Do any additional setup after loading the view.
        var menyNavBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-25.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "toMainMenu")
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = menyNavBtn
    }
    
    func toMainMenu(){
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var container: CastContainerViewController = segue.destinationViewController as CastContainerViewController
        container.cast = self.cast!
    }
    

}
