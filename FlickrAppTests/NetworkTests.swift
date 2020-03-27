//
//  NetworkTests.swift
//  FlickrAppTests
//
//  Created by BinaryBoy on 4/18/19.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

class NetworkTests: XCTestCase {
    
    func testGetItems() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = APIClient(session: session)
        // Create data and tell the session to always return it
        let data: Data? = getData()
        session.data = data
        // Create a URL (using the file path API to avoid optionals)
        let url = URL(fileURLWithPath: "url")
        // Perform the request and verify the result
        manager.loadData(from: url, completion: { (result: Result<FlickrPhoto, FlickrAppError>) in
            switch result {
            case .success(let data):
                guard let photos = data.photos else {
                    XCTFail("Can't get Data")
                    return
                }
                XCTAssertGreaterThan(photos.photoArray.count, 0)
            default:
                XCTFail("Can't get Data")
            }

        })
    }
    
}
