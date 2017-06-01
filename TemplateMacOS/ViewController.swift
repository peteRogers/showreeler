//
//  ViewController.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 29/04/2017.
//  Copyright © 2017 swim. All rights reserved.
//

import Cocoa
import GPUImage
import AVKit
import AVFoundation

class ViewController: NSViewController {
   
    
   
    
    @IBOutlet weak var render: RenderView!
   
    var movie:MovieInput!
    var player:AVPlayer!
    var infoWindowController: NSWindowController!
    var infoVC:InfoViewController!
    var displayLink: CVDisplayLink?
    
    var movieArray: [MovieData]=[]
    public static var animationQueue: DispatchQueue = DispatchQueue.main

    override func viewDidLoad() {
        super.viewDidLoad()
        let mov = MovieData(fileName:"Clone_valley_timelapse.mov", title:"Liboni Munnings", author:"Clone Valley Timelapse", millis: 40000)
        let mov1 = MovieData(fileName:"ZZZ_Branded_Content_02.mp4", title:"Liboni Munnings", author:"ZZZ Branded Content", millis: 81000)
        let mov2 = MovieData(fileName:"ZZZ_Documentary_02.mp4", title:"Liboni Munnings", author:"ZZZ Documentary", millis: 62000)
        let mov3 = MovieData(fileName:"Sequence2.mp4", title:"Peter Rogers", author:"Place Holder Testing", millis: 11000)
        let mov4 = MovieData(fileName:"Sequence1.mp4", title:"Peter Rogers", author:"Place Holder Sound Test", millis: 5000)
        movieArray.append(mov)
        movieArray.append(mov1)
        movieArray.append(mov2)
        movieArray.append(mov3)
        movieArray.append(mov4)
        let mainStoryboard = NSStoryboard.init(name: "Main", bundle: nil)
        infoWindowController = mainStoryboard.instantiateController(withIdentifier: "infoWindow") as! NSWindowController
        infoWindowController.showWindow(self)
        var ff = self.view.frame
        ff.size.width = 1000
        ff.size.height = 800
        ff.origin.x = 0
        ff.origin.y = 0
        
        infoVC = infoWindowController.contentViewController as! InfoViewController
        infoVC.view.backgroundColor(color: NSColor.black)
        infoVC.view.frame = ff
        // print(t.getText(input: "hello you freaks."))
        self.createDisplayLink()
        var f = self.view.frame
        f.size.width = 1280
        f.size.height = 800
        f.origin.x = 0
        f.origin.y = 0
        //self.view.frame = f
       // render.frame = f
        
        self.view.frame = f
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (aEvent) -> NSEvent? in
            self.keyUp(with: aEvent)
            return aEvent
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }

        self.setMoviePlay()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear() {
        setFullScreen()
        self.nextMovie()
    }
    func setFullScreen(){
        /**
        let presOptions: NSApplicationPresentationOptions = ([])
        let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions : presOptions]
        self.view.enterFullScreenMode(NSScreen.main()!, withOptions:optionsDictionary)
        self.view.wantsLayer = true
 **/
       
        var f = self.view.frame
        f.size.width = 1280
        f.size.height = 800
        f.origin.x = 0
        f.origin.y = 0
        //self.view.frame = f
        // render.frame = f
        
        self.view.frame = f
        print(self.view.frame.origin.x)
        print(self.view.frame.origin.y)
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)

    }
    
    func setSize(){
        
    }
    
    func setMoviePlay(){
       /** do {
            let home = FileManager.default.homeDirectoryForCurrentUser
            let folder = home.appendingPathComponent("Desktop/")
            //let bundleURL = Bundle.main.resourceURL!
            //Bundle.main.path(forResource: "soundB", ofType:"mp3")
            let movieURL = URL(string:"sequence1.mp4", relativeTo:folder)!
            movie = try MovieInput(url:movieURL, playAtActualSpeed:true)
           // print(movie.videoFrame?.width)
            let rect = CGRect(x: 0, y: 0, width: 1280, height: 1080)
            //render.frame = rect
            let scale:Float =  Float(render.frame.width/rect.size.width)
            print(render.frame.width)
            print(scale)
            render.frame = rect
            //movie.assetReader.asset.
            //filter = SaturationAdjustment()
            
            movie --> render
            movie.start()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
 */
        let home = FileManager.default.homeDirectoryForCurrentUser
        let folder = home.appendingPathComponent("Desktop/")
        //let bundleURL = Bundle.main.resourceURL!
        //Bundle.main.path(forResource: "soundB", ofType:"mp3")
        print(folder)
        let movieURL = URL(string:"sequence1.mp4", relativeTo:folder)!
        player = AVPlayer(url: movieURL)
       // player.
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.bounds
        
        self.view.wantsLayer = true
        self.view.layer?.addSublayer(playerLayer)
        player.play()
    }
    
    func nextMovie(){
        print(self.view.frame.origin.x)
        print(self.view.frame.origin.y)
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)
        infoVC.makeInfoPanel(array: movieArray)
        movieArray.rearrange(from: movieArray.count-1, to: 0)
        self.view.backgroundColor(color: NSColor.red)
        self.view.layer?.sublayers?.removeAll(keepingCapacity: true)
        let home = FileManager.default.homeDirectoryForCurrentUser
        let folder = home.appendingPathComponent("Desktop/")
        
        let movieURL = URL(string:movieArray[0].fileName, relativeTo:folder)!
        player = AVPlayer(url: movieURL)
        let playerLayer = AVPlayerLayer(player: player)
        print(playerLayer.videoRect.size.width)
        playerLayer.frame = self.view.frame
        //playerLayer.frame.origin.y = -50
        print(playerLayer.videoRect.size.width)

        self.view.wantsLayer = true
        self.view.layer?.addSublayer(playerLayer)
      

        player.play()
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
                if(self.player.rate != 0){
                    
                }else{
                    print("stopped")
                    self.nextMovie()
                }
                //print(self.player.status)
                //print("foof")
                //print(fps)
                /**
                if(self.movie.assetReader.status == .completed){
                    print("completed")
                    self.movie.removeAllTargets()
                    self.setMoviePlay()
                }
 **/
                //self.checkPlayerLevels()
               // self.infoVC.infoLabel.stringValue = String(self.drawView.x)
               // self.drawView.setNeedsDisplay(NSRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(dLink)
    }



}


extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}


struct MovieData {
    let fileName:String
    let title:String
    let author:String
    let millis:Float
    // structure definition goes here
}
