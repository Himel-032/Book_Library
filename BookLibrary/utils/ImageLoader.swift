//
//  ImageLoader.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private static let cache=NSCache<NSString,UIImage>()
    private var cancellable:AnyCancellable?
    private let url:URL?
    
    init(url: URL?){
        self.url=url
        
    }
    
    func load()
    {
        guard !isLoading else {return}
        guard let url=url else {return}
        
        let cacheKey=NSString(string:url.absoluteString)
        if let cachedImage=ImageLoader.cache.object(forKey:cacheKey)
        {
            self.image=cachedImage
            return
        }
        
        isLoading=true
        
        cancellable=URLSession.shared.dataTaskPublisher(for: url)
            .map{UIImage(data:$0.data)}
            .replaceError(with:nil)
            .receive(on:DispatchQueue.main)
            .sink{[weak self] loadedImage in
                self?.isLoading=false
                if let image=loadedImage{
                    ImageLoader.cache.setObject(image,forKey:cacheKey)
                    self?.image=image
                    
                }
            }
        
        
    }
    
    func cancel()
    {
        cancellable?.cancel()
        
    }
    
}

    
    
