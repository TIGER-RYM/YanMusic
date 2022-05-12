//
//  VolumeData.swift
//  Lab05
//
//  Created by Rym- on 8/4/2022.
//

import UIKit

class VolumeData: NSObject, Decodable {
    var musics: [Music]?
    
    private enum CodingKeys:String, CodingKey{
        case musics = "items"
    }
}
