//
//  Music.swift
//  YanMusic
//
//  Created by Rym- on 28/4/2022.
//

import Foundation

class Music: NSObject {
    var musicLink: String?
    var title: String?
    var thumbnailLink: String?
    var length: String?
    var author: String?
    
    init(musicLink: String, title: String, thumbnailLink: String, length: String, author: String) {
        self.musicLink = musicLink
        self.title = title
        self.thumbnailLink = thumbnailLink
        self.length = length
        self.author = author
    }
}
