//
//  UserDefaultSearchHistoryRepositoryTests.swift
//  FlickrAppTests
//
//  Created by BinaryBoy on 3/27/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

class UserDefaultSearchHistoryRepositoryTests: XCTestCase {
    var searchHistoryRepository: UserDefaultSearchHistoryRepository!
    
    override func setUp() {
        // Arrange: setup ViewModel
        searchHistoryRepository = UserDefaultSearchHistoryRepository()
        _ = searchHistoryRepository.clearSearchHistory()
    }
    
    func testGetItemsFromAPI() {
        // Act: get data from API .
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed0")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed1")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed2")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed3")
        let searchTerms = searchHistoryRepository.getSearchHistory()
        // Assert: Verify it's have a data.
        XCTAssertEqual(searchTerms.count, 4)
        
    }
}
