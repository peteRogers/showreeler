//
//  File.swift
//  TemplateMacOS
//
//  Created by Peter Rogers on 26/05/2017.
//  Copyright © 2017 swim. All rights reserved.
//


import Foundation

class TextExtractor{
    func getText(input:String)->String{
        
        do {
            
            guard let start = try input.endIndex(of:"hel")else{
                print("no start")
                return ""
            }
            
            guard let fin = input.index(of:"ss") else{
                print("no end")
                return ""
                
            }
            let distance = input.distance(from: start, to: fin)
            print(distance)
            
            let myRange = start..<fin
            let out = input.substring(with: myRange)
            return out

            
        } catch {
            
        }
        
        
        
        
            }
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



