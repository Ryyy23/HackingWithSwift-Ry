//
//  PhotosClass.swift
//  MilestoneProject 10-12
//
//  Created by Ryordan Panter on 15/3/21.
//

import UIKit

class Photo: NSObject, Codable {
    var image: String
    var caption: String?
    
    init(image: String, caption: String?){
        self.image = image
        self.caption = caption
        
    }
}
