//
//  SearchHistory.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/27/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import Foundation

protocol SearchHistoryRepository {
    func getSearchHistory() -> [String]
    func saveSearchKeyword(searchKeyword: String) -> [String]
    func clearSearchHistory() -> [String]
}
