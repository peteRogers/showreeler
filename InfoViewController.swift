//
//  InfoViewController.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 30/05/2017.
//  Copyright © 2017 swim. All rights reserved.
//

import Cocoa

class InfoViewController: NSViewController {

    @IBOutlet weak var infoLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
    override func viewDidAppear(){
        //makeInfoPanel()
        
    }
    
    func makeInfoPanel(array:[MovieData]){
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        var index:Int = 2
        var time:Float = 0
        let date = Date()
        for item in array.reversed() {
            let cTime = date.addingTimeInterval(TimeInterval(time/1000))
            var height = 90
            if(index == 2){
                height = 60
            }
        let tF = NSTextField(frame: CGRect(x:Int(self.view.frame.width/2)-250,y:Int(self.view.frame.height)-(index*height), width:500, height:85))
        //tF.textColor = NSColor.red
        tF.backgroundColor = NSColor.black
        tF.isBordered = false
            var fontA:CGFloat = 24.0
            if(index == 2){
               fontA = 40
            }
            let font = NSFont(name: "Helvetica Neue Bold", size: fontA)

        let titA : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName : NSColor.white]
            //let str = try NSMutableAttributedString(data: ("I'm a normal text and <b>this is my bold part . </b>And I'm again in the normal text".data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes:nil )
            let str = NSMutableAttributedString(string: "\(item.title)", attributes: titA)
            print(item.title)
            var fontB:CGFloat = 18.0
            if(index == 2){
                fontB = 30
            }
            let ff = NSFont(name: "Helvetica Neue Thin", size: fontB)

            let authA : [String : Any] = [NSFontAttributeName : ff!, NSForegroundColorAttributeName : NSColor.white]
            let strAuth = NSAttributedString(string:"\n\(item.author)\n", attributes:authA)
            str.append(strAuth)
            var fontC:CGFloat = 12.0
            if(index == 2){
                fontC = 24
            }else{
                let font = NSFont(name: "Helvetica Neue Bold Italic", size: fontC)
                let timeA : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName : NSColor.white]
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm:ss"
                let result = formatter.string(from: cTime)
            let strTime = NSAttributedString(string:result, attributes:timeA)
            str.append(strTime)
            }
            //str.addAttributes(attributes,  range: area)
            tF.attributedStringValue = str
            
            //tF.textAlignment = NSTextAlignment.left
       
       // tF.attributedStringValue = "gjgor"
        //tF.stringValue = "hello"
        self.view.addSubview(tF)
        time = time + item.millis
        index = index + 1
        }
    }
}




extension NSView {
    func backgroundColor(color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}
