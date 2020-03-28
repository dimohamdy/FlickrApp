//
//  PhotoCollectionCell.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell, CellReusable {

     let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image  = UIImage(named: "place_holder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.roundCorners(corners: [.allCorners], radius: 10)
        photoImageView.layer.cornerRadius = 18 / 2
        photoImageView.clipsToBounds = true
        photoImageView.layoutIfNeeded()
        
    }
    
    // Bounce Animation
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        
        set {
            super.isHighlighted = newValue
            
            if newValue {
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.75, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.9, y: 0.9)
                })
            } else {
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                })
            }
        }
    }
    
    private func setupViews() {
        [photoImageView].forEach { view in
            addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    func configCell(photo: Photo?) {
        if let imagePath = photo?.imagePath {
            photoImageView.download(from: imagePath, contentMode: .scaleAspectFill)
        } else {
            photoImageView.image =  UIImage(named: "place_holder")
        }
    }
    
}
