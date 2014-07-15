//
//  PlayController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 07/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayController: UIViewController {
    
    var movie: MPMoviePlayerController = MPMoviePlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var url: NSURL = NSURL.fileURLWithPath("https://www.youtube.com/v/gLvmVnKT4cc")
        movie = MPMoviePlayerController(contentURL: url)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish", name: MPMoviePlayerPlaybackDidFinishNotification, object: movie)
        movie.controlStyle = MPMovieControlStyle.Fullscreen // moviePlayer.controlStyle = MPMovieControlStyleDefault;
        self.view.addSubview(movie.view)
        movie.setFullscreen(true, animated: true)
        print("G")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    func moviePlayBackDidFinish(notification: NSNotificationCenter){
        
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
