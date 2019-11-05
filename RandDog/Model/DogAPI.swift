//
//  DogAPI.swift
//  RandDog
//
//  Created by Akan Akysh on 8/21/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case.randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case.randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    //getting information of breeds list in json format
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
        let breedsListEndpoint = self.Endpoint.listAllBreeds.url

        let task = URLSession.shared.dataTask(with: breedsListEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }

            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            
            DispatchQueue.main.async {
                completionHandler(breeds, nil)
            }
        }
        task.resume()
    }
    
    // getting information in json format
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndpoint = self.Endpoint.randomImageForBreed(breed).url
        
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData, nil)
            
        }
         
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        
        task.resume()
    }
    
}
