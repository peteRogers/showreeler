//
//  ViewController.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 29/04/2017.
//  Copyright © 2017 swim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var drawView: DrawView!
    var displayLink: CVDisplayLink?
     public static var animationQueue: DispatchQueue = DispatchQueue.main

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDisplayLink()
        var f = self.view.frame
        f.size.width = 1280
        f.size.height = 800
        self.view.frame = f
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (aEvent) -> NSEvent? in
            self.keyUp(with: aEvent)
            return aEvent
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear() {
        setFullScreen()
    }
    func setFullScreen(){
        let presOptions: NSApplicationPresentationOptions = ([])
        let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions : presOptions]
        self.view.enterFullScreenMode(NSScreen.main()!, withOptions:optionsDictionary)
        self.view.wantsLayer = true

    }
    
    func setSize(){
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        Swift.print("key press")
        if event.keyCode == 123{
            NSApplication.shared().terminate(self)
            
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
                self.drawView.setNeedsDisplay(NSRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(dLink)
    }



}

