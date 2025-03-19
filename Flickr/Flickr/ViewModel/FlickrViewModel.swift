//
//  FlickrViewModel.swift
//  Flickr
//
//  Created by Tridip Sarkar on 18/03/25.
//

import Foundation
import UIKit
// MARK: - ViewModel
class FlickrViewModel {
    
    private  var photos: [FlickrPhoto] = []
    var onPhotosUpdated: ((Bool) -> Void)?
    
    private var cache: ImageCachable!
    private var photoDownloader: PhotoDownloadable!
    
    private var pagingInfo:PagingInfo = (page: 1, pages: Int.max, perpage: 50, total: Int.max)
    
    var isLoading = false
    
    init(photoDownloader: PhotoDownloadable = ConnectionManager.shared,
         cache: ImageCachable = ImageCache.shared) {
        
        self.cache = cache
        self.photoDownloader = photoDownloader
    }
    
    func loadPhotos(isLoadMore: Bool = false) {
        
        if(self.isLoading) { return }
        
        if(isLoadMore){
            
            if(pagingInfo.page < pagingInfo.pages) {
                pagingInfo.page += 1
            }
            else {
                return
            }
        }
        
        self.isLoading = true
        self.photoDownloader?.fetchPhotos(page: pagingInfo.page, limit: pagingInfo.perpage) { [weak self] response in
            
            self?.isLoading = false
            guard let response, let photos = response.photos.photo, photos.count > 0 else {
                self?.onPhotosUpdated?(false)
                return
            }
            self?.pagingInfo.pages = response.photos.pages
            self?.pagingInfo.total = response.photos.total
            
            self?.photos.append(contentsOf: photos)
            DispatchQueue.main.async {
                self?.onPhotosUpdated?(true)
            }
        }
    }
    
    func getPhoto(at index: Int) -> FlickrPhoto? {
        return index >= 0 && index < photos.count ? photos[index] : nil
    }
    
    func getPhotoCount() -> Int {
        return photos.count
    }
    
    func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = self.cache?.image(forUrl: url) {
            completion(cachedImage)
            return
        }
        
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        self.photoDownloader?.downloadPhoto(at: imageUrl) { [weak self] image in
            guard let image else { return }
            self?.cache?.storeImage(image, forUrl: url)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
    }
}
