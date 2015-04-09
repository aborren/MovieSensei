//
//  DiscoverYearViewController.swift
//  MovieSensei
//
//  Created by Dan Isacson on 18/08/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit

class DiscoverYearViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var yearSlider: NMRangeSlider!
    @IBOutlet var startYearLabel: UILabel!
    @IBOutlet var endYearLabel: UILabel!

    @IBOutlet var startPickerView: UIPickerView!
    
    var selectedGenreIDs: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        updateLabel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupSlider(){
        self.yearSlider.tintColor = UIColor.redColor()
        
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear, fromDate: currentDate)
        let currentYear = components.year
        
        self.yearSlider.minimumValue = 1880
        self.yearSlider.lowerValue = 1880
        self.yearSlider.maximumValue = Float(currentYear)
        self.yearSlider.upperValue = Float(currentYear)

        self.yearSlider.stepValue = 1.0
        
        //myskobug
        self.yearSlider.lowerValue = 1880
        
    }
    
    
    @IBAction func upStartYear(sender: AnyObject) {
        self.yearSlider.lowerValue++
        updateLabel()
    }
    @IBAction func downStartYear(sender: AnyObject) {
        self.yearSlider.lowerValue--
        updateLabel()
    }
    
    @IBAction func upEndYear(sender: AnyObject) {
        self.yearSlider.upperValue++
        updateLabel()
    }
    @IBAction func downEndYear(sender: AnyObject) {
        self.yearSlider.upperValue--
        updateLabel()
    }
    
    @IBAction func sliderValueChanged(sender: NMRangeSlider) {
        updateLabel()
    }
    
    func updateLabel(){
        startYearLabel.text = "\(Int(yearSlider.lowerValue))"
        endYearLabel.text = "\(Int(yearSlider.upperValue))"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var resultView = segue.destinationViewController as! DiscoverListViewController
        resultView.selectedGenreIDs = self.selectedGenreIDs
        resultView.minYear = Int(self.yearSlider.lowerValue)
        resultView.maxYear = Int(self.yearSlider.upperValue)

    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
            return "321"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
