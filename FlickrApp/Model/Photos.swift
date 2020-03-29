//
//  Photos.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/23/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import Foundation

struct Photos: Codable {
    
    let page: Int
    let pages: Int
    let perPage: Int
    let total: String
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        
        case page
        case pages
        case perPage = "perpage"
        case photos = "photo"
        case total
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        pages = try values.decode(Int.self, forKey: .pages)
        perPage = try values.decode(Int.self, forKey: .perPage)
        photos = try values.decode([Photo].self, forKey: .photos)
        total = try values.decode(String.self, forKey: .total)
    }
}
