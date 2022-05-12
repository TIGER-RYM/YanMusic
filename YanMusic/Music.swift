//
//  Music.swift
//  YanMusic
//
//  Created by Rym- on 28/4/2022.
//

import Foundation

class Music: NSObject, Decodable {
    var musicLink: String?
    var title: String?
    var thumbnailLink: String?
    var length: String?
    var author: String?
    var musicID: String?
    
    private enum MusicKeys: String, CodingKey{
        case title
        case id
        case bestThumbnail
        case author
        case duration
    }
    
    private enum AuthorKeys: String, CodingKey {
        case name
    }

    private enum ThumbnailKeys: String, CodingKey {
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: MusicKeys.self)
        let imageContainer = try? rootContainer.nestedContainer(keyedBy: ThumbnailKeys.self, forKey: .bestThumbnail)
        let authorContainer = try? rootContainer.nestedContainer(keyedBy: AuthorKeys.self, forKey: .author)
        
        title = try? rootContainer.decode(String.self, forKey: .title)
        thumbnailLink = try imageContainer?.decode(String.self, forKey: .url)
        length = try? rootContainer.decode(String.self, forKey: .duration)
        author = try authorContainer?.decode(String.self, forKey: .name)
        musicID = try? rootContainer.decode(String.self, forKey: .id)
    }
}
