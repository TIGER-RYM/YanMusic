//
//  Music.swift
//  YanMusic
//
//  Created by Rym- on 28/4/2022.
//

import Foundation
import UIKit

class Music: NSObject, Decodable {
    var title: String?
    var thumbnailLink: String?
    var length: String?
    var author: String?
    var musicID: String?
    var musicImage: UIImage?
    
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
        super.init()
        let rootContainer = try decoder.container(keyedBy: MusicKeys.self)
        let imageContainer = try? rootContainer.nestedContainer(keyedBy: ThumbnailKeys.self, forKey: .bestThumbnail)
        let authorContainer = try? rootContainer.nestedContainer(keyedBy: AuthorKeys.self, forKey: .author)
        
        title = try? rootContainer.decode(String.self, forKey: .title)
        thumbnailLink = try imageContainer?.decode(String.self, forKey: .url)
        guard let urlString = thumbnailLink, let url = URL(string: urlString) else {
            return
        }
        Task {
            do {
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                if let image = UIImage(data: data) {
                    let targetSize = CGSize(width: 366, height: 130)

                    // Compute the scaling ratio for the width and height separately
                    let widthScaleRatio = targetSize.width / image.size.width
                    let heightScaleRatio = targetSize.height / image.size.height

                    // To keep the aspect ratio, scale by the smaller scaling ratio
                    let scaleFactor = min(widthScaleRatio, heightScaleRatio)

                    // Multiply the original image’s dimensions by the scale factor
                    // to determine the scaled image size that preserves aspect ratio
                    let scaledImageSize = CGSize(
                        width: image.size.width * scaleFactor,
                        height: image.size.height * scaleFactor
                    )
                    let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
                    let scaledImage = renderer.image { _ in
                        image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
                    }
                    self.musicImage = scaledImage
                }
            } catch let error{
                print(error)
            }
        }
        length = try? rootContainer.decode(String.self, forKey: .duration)
        author = try authorContainer?.decode(String.self, forKey: .name)
        musicID = try? rootContainer.decode(String.self, forKey: .id)
    }
}
