//
//  main.swift
//  ParseWordList
//
//  Created by Ryordan Panter on 13/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import Foundation

var allWords = [String]()
var newallWords = [String]()

let file = "/Users/ryordanpanter/Projects/Aspell-wordlist copy.txt"
let path = URL(fileURLWithPath: file)
if let text = try?  String(contentsOf: path){

    allWords = text.components(separatedBy: "\n")
    let temp = allWords.filter({!$0.contains("'")})
    allWords = temp
}
let writeFile = allWords.joined(separator: "\n")
try writeFile.write(to: path, atomically: true, encoding: String.Encoding.utf8)



