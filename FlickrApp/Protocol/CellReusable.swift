//
//  CellReusable.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/24/20.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import Foundation

protocol CellReusable {
    static var identifier: String { get }
}

extension CellReusable {
    static var identifier: String {
        return "\(self)"
    }
}
