//
//  DrawView.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 02/05/2017.
//  Copyright © 2017 swim. All rights reserved.
//

import Cocoa

class DrawView: NSView {
    var x = 0.0
    var y = 0.0

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //Swift.print("hello")
        let context = NSGraphicsContext.current()?.cgContext
        context?.fillEllipse (in: CGRect(x: x, y: y, width: 50, height: 50))
        x = x + 0.1
        y = y + 0.1
        // Drawing code here.
    }
    
    
    
}
