//
//  FlickrPhoto.swift
//  Flickr
//
//  Created by Tridip Sarkar on 18/03/25.
//

import Foundation
// MARK: - Data Model
struct FlickrPhoto: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    
    var imageUrl: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
    }
}

struct FlickrResponse: Codable {
    let photos: FlickrPhotoContainer
}

struct FlickrPhotoContainer: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    
    let photo: [FlickrPhoto]?
}
