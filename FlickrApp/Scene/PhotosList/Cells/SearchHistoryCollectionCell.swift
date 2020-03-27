//
//  SearchHistoryCollectionCell.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/27/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import UIKit

class SearchHistoryCollectionCell: UICollectionViewCell, CellReusable {
    
    
    private var searchTermLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
        addSubview(searchTermLabel)
        
        NSLayoutConstraint.activate([
            searchTermLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchTermLabel.topAnchor.constraint(equalTo: topAnchor),
            searchTermLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchTermLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
    func configCell(searchTerm: String) {
        searchTermLabel.text = searchTerm
    }
    
}
