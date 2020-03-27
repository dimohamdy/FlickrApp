//
//  PhotosRepository.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/25/20.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import Foundation

protocol PhotosRepository {

    func photos(for query: String, page: Int, completion: @escaping (Result< FlickrPhoto, FlickrAppError>) -> Void)
}
