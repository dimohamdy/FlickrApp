//
//  DataSource.swift
//  FlickrApp
//
//  Created by BinaryBoy on 4/18/19.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import Foundation

protocol PhotosRepository {

    func photos(for query: String, page: Int, completion: @escaping (Result< PhotosResult, FlickrAppError>) -> Void)
}
