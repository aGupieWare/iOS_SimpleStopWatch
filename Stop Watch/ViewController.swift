//
//  ViewController.swift
//  Stop Watch
//
//  Created by Stefan Agapie on 8/2/14.
//  Copyright (c) 2014 aGupieWare. All rights reserved.
//
//  This file is part of Stop Watch.
//
//  Stop Watch is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Stop Watch is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Stop Watch.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    @IBOutlet weak var numericDisplay: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    
    var displayLink: CADisplayLink!
    var lastDisplayLinkTimeStamp: CFTimeInterval!
                                
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set default view element values //
        self.numericDisplay.text = "0.00"
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.startStopButton.setTitle("Start", forState: UIControlState.Normal)
        
        // Initializing the display link and directing it to call our displayLinkUpdate: method when an update is available //
        self.displayLink = CADisplayLink(target: self, selector: "displayLinkUpdate:")
        
        // Ensure that the display link is initially not updating //
        self.displayLink.paused = true;
        
        // Scheduling the Display Link to Send Notifications //
        self.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
        // Initial timestamp //
        self.lastDisplayLinkTimeStamp = self.displayLink.timestamp
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func resetButtonPressed(sender: AnyObject) {
        
        // Pause display link updates //
        self.displayLink.paused = true;
        
        // Set default numeric display value //
        self.numericDisplay.text = "0.00"
        
        // Set button to Start state //
        self.startStopButton.setTitle("Start", forState: UIControlState.Normal)
        
        // Reset our running tally //
        self.lastDisplayLinkTimeStamp = 0.0
    }

    @IBAction func startStopButtonPressed(sender: AnyObject) {
        
        // Toggle the display link's paused boolean value //
        self.displayLink.paused = !(self.displayLink.paused)
        
        // if the display link is not updating us... //
        var buttonText:String = "Stop"
        if self.displayLink.paused {
            if self.lastDisplayLinkTimeStamp > 0 {
                buttonText = "Resume"
            }
            else {
                buttonText = "Start"
            }
        }
        self.startStopButton.setTitle(buttonText, forState: UIControlState.Normal)
    }
    
    func displayLinkUpdate(sender: CADisplayLink) {
        
        // Update running tally //
        self.lastDisplayLinkTimeStamp = self.lastDisplayLinkTimeStamp + self.displayLink.duration
        
        // Format the running tally to display on the last two significant digits //
        let formattedString:String = String(format: "%0.2f", self.lastDisplayLinkTimeStamp)
        
        // Display the formatted running tally //
        self.numericDisplay.text = formattedString;
    }
}

