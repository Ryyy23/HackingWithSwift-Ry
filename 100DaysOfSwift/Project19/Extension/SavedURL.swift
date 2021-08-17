//
//  SavedURL.swift
//  Extension
//
//  Created by Ryordan Panter on 17/8/21.
//

import Foundation

struct SavedURL: Codable {
    let name : String
    let url : URL
    let customJavaScript: String
}
