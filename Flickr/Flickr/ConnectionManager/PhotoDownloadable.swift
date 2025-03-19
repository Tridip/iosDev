//
//  PhotoDownloadable.swift
//  Flickr
//
//  Created by Tridip Sarkar on 19/03/25.
//

import Foundation
import UIKit

protocol PhotoDownloadable {
    
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (FlickrResponse?) -> Void)
    func downloadPhoto(at url: URL, completion: @escaping (UIImage?) -> Void)
}
