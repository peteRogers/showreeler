//
//  InfoViewController.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 30/05/2017.
//  Copyright © 2017 swim. All rights reserved.
//

import Cocoa
import Alamofire

class InfoViewController: NSViewController {

    @IBOutlet weak var infoLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
    override func viewDidAppear(){
        //makeInfoPanel()
        
    }
    
    func sendListToWeb(dict:Dictionary<String, AnyObject>){
        
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            //jsonData.
            //Do this for print data only otherwise skip
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
            //var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
            let urlString = "http://34.251.98.79:8080/test"
            
            let url = URL(string: urlString)!
            //let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            Alamofire.request(request).responseJSON {
                (response) in
                
                print(response)
            }

            
        } catch {
            print(error.localizedDescription)
        }
        
       
    }
    
    func makeInfoPanel(array:[MovieData]){
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        var index:Int = 2
        var time:Float = 0
        let date = Date()
        var dictOut : [String: AnyObject] = [:]
        
        var dictArray:[Dictionary<String, String>] = []
        
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
            //print(item.title)
            var fontB:CGFloat = 18.0
            if(index == 2){
                fontB = 30
            }
            let ff = NSFont(name: "Helvetica Neue Thin", size: fontB)

            let authA : [String : Any] = [NSFontAttributeName : ff!, NSForegroundColorAttributeName : NSColor.white]
            let strAuth = NSAttributedString(string:"\n\(item.author)\n", attributes:authA)
            str.append(strAuth)
            var fontC:CGFloat = 12.0
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let result = formatter.string(from: cTime)
            if(index == 2){
                fontC = 24
            }else{
                let font = NSFont(name: "Helvetica Neue Bold Italic", size: fontC)
               let timeA : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName : NSColor.white]
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
            let myDict = ["title":item.title, "author":item.author, "time":result]
            dictArray.append(myDict)

        index = index + 1
        }
        dictOut["list"] = dictArray as AnyObject
        self.sendListToWeb(dict: dictOut)
    }
}




extension NSView {
    func backgroundColor(color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}

