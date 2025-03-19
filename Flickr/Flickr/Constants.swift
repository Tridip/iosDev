//
//  Constants.swift
//  Flickr
//
//  Created by Tridip Sarkar on 18/03/25.
//

import Foundation

struct Constants
{
    static let API_KEY = "de24642a8668fb0318ec5b9cecfda18c"
    /* static let URL_STRING = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(API_KEY)&format=json&nojsoncallback=1"
     */
    static let URL_STRING = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(API_KEY)&per_page=50&page=10&format=json&nojsoncallback=1"
    
    static func getURLString(page: Int = 1, limit: Int = 50) -> String {
        return "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(API_KEY)&per_page=\(limit)&page=\(page)&format=json&nojsoncallback=1"
    }
}

typealias PagingInfo = (
    page: Int,
    pages: Int,
    perpage: Int,
    total: Int
)

