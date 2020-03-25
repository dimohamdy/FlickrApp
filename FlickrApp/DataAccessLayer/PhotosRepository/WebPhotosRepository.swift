//
//  Web PhotosRepository.swift
//  FlickrApp
//
//  Created by BinaryBoy on 4/18/19.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import Foundation

final class WebPhotosRepository: PhotosRepository {

    let client: APIClient!
    init(client: APIClient = APIClient()) {
        self.client =  client
    }

    func photos(for query: String, page: Int, completion: @escaping (Result< PhotosResult, FlickrAppError>) -> Void){
        let path = APILinksFactory.API.search(text: query,perPage: 10,page: page).path

        guard let url = URL(string:path) else { return }
        print(path)
        client.loadData(from: url) { (result: Result<PhotosResult, FlickrAppError>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
}

enum FlickrAppError: Error {
    case failedConnection
    case idError
    case noResults
    case noInternetConnection
    case unknownError
    case runtimeError(String)
    var localizedDescription: String {
        switch self {
        case .noResults:
            return "No result found"
        case .noInternetConnection:
            return "No Internet Connection"
        case .unknownError:
            return "something wrong Happen, please try other time"
        default:
            return "something wrong Happen, please try other time"
        }
    }
}
