//
//  UIImageView+DownloadImage.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/24/20.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

    func download(from path: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: path) else { return }
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: #imageLiteral(resourceName: "place_holder"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
