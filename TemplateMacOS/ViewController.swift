//
//  ViewController.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 29/04/2017.
//  Copyright © 2017 swim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var displayLink: CVDisplayLink?
     public static var animationQueue: DispatchQueue = DispatchQueue.main

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func createDisplayLink() {
        let error = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard let dLink = displayLink, kCVReturnSuccess == error else {
           // N//SLog("Display Link created with error: %d", error)
            self.displayLink = nil
            return
        }
        
        /// nowTime is the current frame time, and outputTime is when the frame will be displayed.
        CVDisplayLinkSetOutputHandler(dLink) { (_, nowTime, outputTime, _, _) in
            let fps = (outputTime.pointee.rateScalar * Double(outputTime.pointee.videoTimeScale) / Double(outputTime.pointee.videoRefreshPeriod))
            ViewController.animationQueue.async {
                //print("foof")
                print(fps)
                //self.checkPlayerLevels()
            }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(dLink)
    }



}

