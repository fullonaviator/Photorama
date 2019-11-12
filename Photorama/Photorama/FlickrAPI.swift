//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Burton, Andrew M on 11/12/19.
//  Copyright © 2019 Burton, Andrew M. All rights reserved.
//

import Foundation
import UIKit

typealias PhotosResult = Swift.Result<[Photo],Error>
typealias PhotosResultClosure = (PhotosResult) -> Void

typealias ImageResult = Swift.Result<UIImage,Error>
typealias ImageResultClosure = (ImageResult) -> Void

enum ImageErrors: Error {
    case networkError(Error)
    case decodingError
    case noData
}
enum PhotosErrors: Error {
    case badURL
    case networkError(Error)
    case decodingError(Error)
    case noData
}
class FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest/"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    private static let commonParams: [String:String] = [
        "nojsoncallback": "1",
        "format": "json",
        "api_key": apiKey
    ]
    
    public enum Method: String {
        case interestingPhotos = "flickr.interestingness.getList"
        case recentPhotos = "flickr.photos.getRecent"
    }
    
    public class func fetchInterestingPhotos(page: Int = 1, perPage: Int = 100, completion: @escaping PhotosResultClosure) {
        
        // Construct the url
        guard let url = url(forMethod: .interestingPhotos,
                            queryParams: ["per_page": "\(perPage)",
                                "page": "\(page)",
                                "extras": "url_h"]) else {
                                    let result: PhotosResult = .failure(PhotosErrors.badURL)
                                    completion(result)
                                    return
        }
        
        print("url=\(url)")
        
        // Build our URLRequest
        let urlRequest = URLRequest(url: url)
        
        // Create our data task
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            let result: PhotosResult
            if let error = error {
                let networkError = PhotosErrors.networkError(error)
                result = PhotosResult.failure(networkError)
            } else if let data = data {
                if let prettyStr = FlickrAPI.prettyPrintedJSONString(fromData: data) {
                    print("JSON=\n\(prettyStr)")
                }
                let decoder = JSONDecoder()
                do {
                    let photosResponse = try decoder.decode(InterestingListResponse.self, from: data)
                    result = PhotosResult.success(photosResponse.photos.photo)
                } catch {
                    let decodingError = PhotosErrors.decodingError(error)
                    result = PhotosResult.failure(decodingError)
                }
            } else {
                let noDataError = PhotosErrors.noData
                result = PhotosResult.failure(noDataError)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        })
        
        task.resume()
    }
    
    public class func fetchImage(fromURL url: URL, completion: @escaping ImageResultClosure) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            let result: ImageResult
            if let error = error {
                let imageError = ImageErrors.networkError(error)
                result = ImageResult.failure(imageError)
            } else if let data = data {
                if let image = UIImage(data: data) {
                    result = ImageResult.success(image)
                } else {
                    let decodingError = ImageErrors.decodingError
                    result = ImageResult.failure(decodingError)
                }
            } else {
                result = ImageResult.failure(ImageErrors.noData)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        })
        task.resume()
    }
    
    
    private class func url(forMethod method: Method, queryParams: [String:String]) -> URL? {
        guard var urlComponents = URLComponents(string: baseURLString) else {
            return nil
        }
        
        var queryItems = [URLQueryItem]()
        
        // Method
        let methodQueryItem = URLQueryItem(name: "method", value: method.rawValue)
        queryItems.append(methodQueryItem)
        
        // Common params
        for (name, value) in commonParams {
            let queryItem = URLQueryItem(name: name, value: value)
            queryItems.append(queryItem)
        }
        
        // Passed-in query params
        for (name, value) in queryParams {
            let queryItem = URLQueryItem(name: name, value: value)
            queryItems.append(queryItem)
        }
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    private class func prettyPrintedJSONString(fromData data: Data) -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(data: prettyData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
}

