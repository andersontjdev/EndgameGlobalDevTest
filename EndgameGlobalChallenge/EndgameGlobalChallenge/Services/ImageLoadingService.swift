//
//  ImageLoadingService.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import UIKit

class ImageLoadingService {
    
    static let shared = ImageLoadingService()
    
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        
        self.session = URLSession(configuration: configuration)
        
        // Configure the cache
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 /// 50MB
    }
    
    // MARK: Public Functions
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check for an image in the cache first
        let cacheKey = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            
            return
        }
        
        // Load image from the network
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                return
            }
            
            // Store the image in the cache
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
}
