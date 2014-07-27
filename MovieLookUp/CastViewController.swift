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
        var backNavBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-25.png"), style: UIBarButtonItemStyle.Done, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = backNavBtn

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(){
        self.navigationController.popToViewController(self.navigationController.viewControllers[self.navigationController.viewControllers.count-2] as UIViewController, animated: true)
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
