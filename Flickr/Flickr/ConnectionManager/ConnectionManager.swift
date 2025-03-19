//
//  ConnectionManager.swift
//  Flickr
//
//  Created by Tridip Sarkar on 18/03/25.
//

import Foundation
import UIKit
// MARK: - Connection Manager
// This class perform network connection and download data
class ConnectionManager {
    static let shared = ConnectionManager()
    private init() {}
    //downloadData - downloads data for given url
    func downloadData(from url: URL, completion: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completion)
        dataTask.resume()
    }
}

extension ConnectionManager: PhotoDownloadable {
    
    //fetchPhotos - is used to fetch all image information per page and also page number, perpage, pages, total
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (FlickrResponse?) -> Void) {
        let urlString = Constants.getURLString(page: page, limit: limit)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        self.downloadData(from: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FlickrResponse.self, from: data)
                completion(decodedResponse)
            } catch {
                completion(nil)
            }
        }
    }
    //downloadPhoto - downloads image for a given url
    func downloadPhoto(at url: URL, completion: @escaping (UIImage?) -> Void) {
        self.downloadData(from: url) { data, _, _ in
            if let data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}
