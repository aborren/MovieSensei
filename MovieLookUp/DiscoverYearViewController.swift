//
//  DiscoverYearViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 18/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class DiscoverYearViewController: UIViewController {

    @IBOutlet var yearSlider: NMRangeSlider!
    @IBOutlet var yearLabel: UILabel!
    
    var selectedGenreIDs: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupSlider(){
        
        self.yearSlider.minimumValue = 1950.0
        self.yearSlider.lowerValue = 1950.0
        self.yearSlider.maximumValue = 2014.0
        self.yearSlider.upperValue = 2014.0

        self.yearSlider.stepValue = 1.0
        
        //myskobug
        self.yearSlider.lowerValue = 1950.0
        
    }
    
    
    @IBAction func sliderValueChanged(sender: NMRangeSlider) {
        yearLabel.text = "Min: \(yearSlider.lowerValue) Max: \(yearSlider.upperValue)"
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var resultView = segue.destinationViewController as DiscoverListViewController
        resultView.selectedGenreIDs = self.selectedGenreIDs
        resultView.minYear = Int(self.yearSlider.lowerValue)
        resultView.maxYear = Int(self.yearSlider.upperValue)

    }


}
