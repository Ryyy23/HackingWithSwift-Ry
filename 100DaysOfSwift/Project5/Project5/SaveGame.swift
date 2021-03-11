//
//  SaveGame.swift
//  Project5
//
//  Created by Ryordan Panter on 11/3/21.
//  Copyright © 2021 Ryordan Panter. All rights reserved.
//

import UIKit

class SaveGame: NSObject, Codable {
    var currentWord: String
    var usedWords: [String]
    
    init(currentWord: String, usedWords: [String]) {
        self.currentWord = currentWord
        self.usedWords = usedWords
    }
}

