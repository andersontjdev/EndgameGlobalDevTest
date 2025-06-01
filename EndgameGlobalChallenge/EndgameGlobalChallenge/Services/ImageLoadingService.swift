//
//  ImageLoadingService.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import UIKit

actor ImageLoadingService {
    
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
    
    func loadImage(from urlString: String) async -> UIImage? {
        // Check for an image in the cache first
        let cacheKey = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Load image from the network
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            // Store the image in the cache
            self.cache.setObject(image, forKey: cacheKey)
            
            return image
        } catch {
            print("ImageLoadingService: Failed to load image from \(urlString) - \(error)")
            return nil
        }
    }
}
