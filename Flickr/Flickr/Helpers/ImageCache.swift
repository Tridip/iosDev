//
//  ImageCache.swift
//  Flickr
//
//  Created by Tridip Sarkar on 19/03/25.
//

import Foundation
import UIKit


protocol ImageCachable {
    func storeImage(_ image: UIImage, forUrl key: String)
    func image(forUrl key: String) -> UIImage?
}

//ImageCache - is a mechanism used to temporarily store images in memory to improve performance and reduce unnecessary network requests
class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    static let shared = ImageCache()
    private init() {}
}

extension ImageCache: ImageCachable {
    func storeImage(_ image: UIImage, forUrl key: String) {
        self.cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forUrl key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
}
