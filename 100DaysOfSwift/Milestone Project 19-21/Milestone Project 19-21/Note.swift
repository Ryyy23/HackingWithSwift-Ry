//
//  Note.swift
//  Milestone Project 19-21
//
//  Created by Ryordan Panter on 3/2/2022.
//

import Foundation

class Note: NSObject, Codable {
    var name: String
    var body: String
    
    init(name: String, body: String) {
        self.name = name
        self.body = body
    }
}
