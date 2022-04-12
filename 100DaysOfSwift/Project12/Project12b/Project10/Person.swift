//
//  Person.swift
//  Project10
//
//  Created by Ryordan Panter on 16/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import Foundation

class Person: NSObject, Codable {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
