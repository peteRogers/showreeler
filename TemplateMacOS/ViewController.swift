//
//  ViewController.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 29/04/2017.
//  Copyright © 2017 swim. All rights reserved.
//

import Cocoa
//import GPUImage
import CSVImporter
import AVKit
import AVFoundation
import Alamofire
class ViewController: NSViewController {
   
    
      // @IBOutlet weak var render: RenderView!
    //var moviePosition = 0
    //var movie:MovieInput!
    var playingTimer: Timer!
    var player:AVPlayer!
    var infoWindowController: NSWindowController!
    var infoVC:InfoViewController!
    
    var titleView:NSView!
    //var displayLink: CVDisplayLink?
    
    var movieArray: [MovieData]=[]
    public static var animationQueue: DispatchQueue = DispatchQueue.main

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getCSV()
        /**
        let mov = MovieData(fileName:"Clone_valley_timelapse.mov", title:"Liboni Munnings", author:"Clone Valley Timelapse", millis: 40000)
        let mov1 = MovieData(fileName:"ZZZ_Branded_Content_02.mp4", title:"Liboni Munnings", author:"ZZZ Branded Content", millis: 81000)
        let mov2 = MovieData(fileName:"ZZZ_Documentary_02.mp4", title:"Liboni Munnings", author:"ZZZ Documentary", millis: 62000)
        let mov3 = MovieData(fileName:"Sequence2.mp4", title:"Peter Rogers", author:"Place Holder Testing", millis: 11000)
        let mov4 = MovieData(fileName:"Sequence1.mp4", title:"Peter Rogers", author:"Place Holder Sound Test", millis: 5000)
        let mov6 = MovieData(fileName:"Clone_valley_timelapse.mov", title:"Liboni Munnings", author:"Clone Valley Timelapse", millis: 40000)
        let mov7 = MovieData(fileName:"ZZZ_Branded_Content_02.mp4", title:"Liboni Munnings", author:"ZZZ Branded Content", millis: 81000)
        let mov8 = MovieData(fileName:"ZZZ_Documentary_02.mp4", title:"Liboni Munnings", author:"ZZZ Documentary", millis: 62000)
        let mov9 = MovieData(fileName:"Sequence2.mp4", title:"Peter Rogers", author:"Place Holder Testing", millis: 11000)
        let mov10 = MovieData(fileName:"Sequence1.mp4", title:"Peter Rogers", author:"Place Holder Sound Test", millis: 5000)
        movieArray.append(mov)
        movieArray.append(mov1)
        movieArray.append(mov2)
        movieArray.append(mov3)
        movieArray.append(mov6)
        movieArray.append(mov7)
        movieArray.append(mov8)
        movieArray.append(mov9)
        movieArray.append(mov10)
 **/
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

        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear() {
        setFullScreen()
       // self.nextMovie()
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
    
    ////////
    
//MARK: CSV Functions
    
    func getCSV(){
       // print("foof")
        let home = FileManager.default.homeDirectoryForCurrentUser
        let folder = home.appendingPathComponent("Desktop/movieMeta.csv")
        let sta = folder.absoluteString.endIndex(of:"file://")
        let f = folder.absoluteString.substring(from: sta!)
        let importer = CSVImporter<MovieData>(path: f)
        importer.startImportingRecords { recordValues -> MovieData in
            print(recordValues[0])
            return MovieData(fileName: recordValues[0], title: recordValues[1], author: recordValues[2], millis: Float(recordValues[3])!, showTitle:Int(recordValues[4])!)
            
            }.onFinish { importedRecords in
               
                
                self.movieArray = importedRecords
                /**
                for _ in 0...self.moviePosition-1{
                    self.movieArray.rearrange(from: self.movieArray.count-1, to: 0)
                }
**/
                //print(self.movieArray.count)
                self.setMoviePlay()
                //self.createDisplayLink()

        }
    }
    
    
    
    
    
    
    func setMoviePlay(){
        let home = FileManager.default.homeDirectoryForCurrentUser
        let folder = home.appendingPathComponent("Desktop/showVideos/")
        //let bundleURL = Bundle.main.resourceURL!
        //Bundle.main.path(forResource: "soundB", ofType:"mp3")
        print(folder)
        let movieURL = URL(string:"sequence2.mp4", relativeTo:folder)!
        player = AVPlayer(url: movieURL)
       // player.
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.bounds
        
        self.view.wantsLayer = true
        self.view.layer?.addSublayer(playerLayer)
        player.play()
        playingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(checkIfFinished), userInfo: nil, repeats: true)
        
    }
    
    func nextMovie(){
        /**
        print(self.view.frame.origin.x)
        print(self.view.frame.origin.y)
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)
        **/
        //print("eeekk")
        infoVC.makeInfoPanel(array: movieArray)
        //moviePosition = moviePosition + 1
        //defaults.set(moviePosition, forKey: "pos")
       // print(moviePosition)
        movieArray.rearrange(from: movieArray.count-1, to: 0)
        self.view.backgroundColor(color: NSColor.black)
        self.view.layer?.sublayers?.removeAll(keepingCapacity: true)
        let home = FileManager.default.homeDirectoryForCurrentUser
        let folder = home.appendingPathComponent("Desktop/showVideos/")
        //player.pause()
        // print(folder.absoluteString)
       
        let movieURL = URL(string:movieArray[0].fileName, relativeTo:folder)!
        player = AVPlayer(url: movieURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        self.view.wantsLayer = true
        self.view.layer?.addSublayer(playerLayer)
        
        if(movieArray[0].showTitle == 1){
        //start of adding title view
        var f = self.view.frame
        f.size.width = 1280
        f.size.height = 800
        f.origin.x = 0
        f.origin.y = 0
        //self.view.frame = f
        // render.frame = f
        
        self.view.frame = f
        titleView?.removeFromSuperview()
        titleView = NSView(frame: f)
        titleView.wantsLayer = true
        titleView.layer?.backgroundColor = NSColor.black.cgColor
        let s = NSTextField(frame: CGRect(x:50,y:200, width:f.size.width-100, height:400))
        let font = NSFont(name: "Helvetica Neue Bold", size: 50)
        
        let titA : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName : NSColor.white]
        let str = NSMutableAttributedString(string: "\(movieArray[0].title)\n\(movieArray[0].author)", attributes: titA)
        s.backgroundColor = NSColor.black
        s.textColor = NSColor.white
        s.attributedStringValue = str
        s.isBordered = false
        
        titleView.addSubview(s)
        
        self.view.addSubview(titleView, positioned: NSWindowOrderingMode.above, relativeTo: nil)
        titleView.alphaValue = 1.0
        NSAnimationContext.runAnimationGroup({_ in
            //Indicate the duration of the animation
            NSAnimationContext.current().duration = 5.0
            //What is being animated? In this example I’m making a view transparent
            titleView.animator().alphaValue = 0.99
        }, completionHandler:{
            //In here we add the code that should be triggered after the animation completes.
            print("Animation completed")
            self.titleView?.removeFromSuperview()
            //self.nextMovie()
            self.player.play()
            self.playingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.checkIfFinished), userInfo: nil, repeats: true)
        })
        
        }else{
            self.player.play()
            self.playingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.checkIfFinished), userInfo: nil, repeats: true)
        }
        
                //self.createDisplayLink()
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
    
    func checkIfFinished(){
        print("doing check if finished")
        print(self.player.timeControlStatus.rawValue)
        if(self.player.timeControlStatus.rawValue != 0){
            
        }else{
            print("stopped")
           
            playingTimer.invalidate()
            self.nextMovie()
            
          
            
            
        }

    }
    
    
    /**
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
                if(self.player.rate != 0  ){
                    
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

**/

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
    let showTitle:Int
    // structure definition goes here
}

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}


