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
    
    
    //loadPhotos - this function is called to load more images on dragging collection view to upwords.
    func loadPhotos(isLoadMore: Bool = false) {
        
        if(self.isLoading) { return }
        
        if(isLoadMore){  //if isLoadMore is true and isLoading is false (i.e loading is not happening), we can increment the current page to load more images on dragging collection view to upwords.
            
            if(pagingInfo.page < pagingInfo.pages) {
                pagingInfo.page += 1
            }
            else {
                return
            }
        }
        
        self.isLoading = true // this flag says that loading is ongoing
        //fetchPhotos - is used to fetch all image information per page and also page number, perpage count, count of pages and total number of images. Append the contents of photos i.e FlickrPhoto into photos array.
        self.photoDownloader?.fetchPhotos(page: pagingInfo.page, limit: pagingInfo.perpage) { [weak self] response in
            
            self?.isLoading = false // this flag says that loading done
            guard let response, let photos = response.photos.photo, photos.count > 0 else {
                self?.onPhotosUpdated?(false)
                return
            }
            self?.pagingInfo.pages = response.photos.pages
            self?.pagingInfo.total = response.photos.total
            
            self?.photos.append(contentsOf: photos) //Append the contents of photos i.e FlickrPhoto into photos array.
            DispatchQueue.main.async { //back to the main thread, to update the view
                self?.onPhotosUpdated?(true)
            }
        }
    }
    
    //getPhoto - checks the array index within the bound and returns FlickrPhoto information for a particular index.
    func getPhoto(at index: Int) -> FlickrPhoto? {
        return index >= 0 && index < photos.count ? photos[index] : nil
    }
    
    //getPhotoCount - returns the total count of the photo
    func getPhotoCount() -> Int {
        return photos.count
    }
    
    //loadImage - checks whether an image for the given url already cached in memory. If the image is already cached, send this image to completion handler for use. If the image is not found from cache, this method downloads the image, cache it and send this image to completion handler for use.
    
    func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        //Here checks whether an image for the given url already cached in memory.
        if let cachedImage = self.cache?.image(forUrl: url) {
            completion(cachedImage)  //send this image to completion handler for use
            return
        }
        
        //Here checks whether given url exists for downloading the image.
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        // Here image is being downloaded, cache it and send this image to completion handler for use.
        self.photoDownloader?.downloadPhoto(at: imageUrl) { [weak self] image in
            guard let image else { return }
            self?.cache?.storeImage(image, forUrl: url)
            DispatchQueue.main.async { //back to the main thread
                completion(image)
            }
        }
        
    }
}
