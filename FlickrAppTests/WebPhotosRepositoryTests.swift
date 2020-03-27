//
//  WebPhotosRepositoryTests.swift
//  FlickrAppTests
//
//  Created by BinaryBoy on 4/18/19.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

class WebPhotosRepositoryTests: XCTestCase {
    var webPhotosRepository: WebPhotosRepository!
    
    override func setUp() {
        // Arrange: setup ViewModel
        webPhotosRepository = WebPhotosRepository()
    }
    
    func testGetItemsFromAPI() {
        // Act: get data from API .
        webPhotosRepository.photos(for: "Car", page: 1) { (result) in
            switch result {
            case .success(let data):
                guard let photos = data.photos?.photoArray, !photos.isEmpty else {
                    return
                }
                // Assert: Verify it's have a data.
                XCTAssertGreaterThan(photos.count, 0)
                XCTAssertEqual(photos.count, 10)
            default:
                XCTFail("Can't get Data")
            }

        }
    }
}
