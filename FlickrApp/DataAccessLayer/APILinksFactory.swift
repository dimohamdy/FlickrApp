//
//  APILinksFactory.swift
//  FlickrApp
//
//  Created by BinaryBoy on 4/22/20.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import Foundation

struct APILinksFactory {

    #warning("Replace your API Key in API_KEY ")
    private static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=API_KEY&format=json&nojsoncallback=1"
    
    enum API {
        case search(text: String, perPage: Int, page: Int)

        var path: String {
            switch self {
            case .search(let text, let perPage, let page):
                return APILinksFactory.baseURL + "&text=\(text)&per_page=\(perPage)&page=\(page)"
            }
        }
    }
}
