//
//  PhotosCollectionViewCell.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    private enum Constants {
        static let itemCount: CGFloat = 3
    }
    lazy var photoImage: UIImageView = {
        let photoImage = UIImageView()
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.contentMode = .scaleAspectFill
        photoImage.clipsToBounds = true
        return photoImage
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.photoImage)
        let topConstraint = self.photoImage.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        let centerX = self.photoImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        let centerY = self.photoImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        let photoAspectRatio = self.photoImage.heightAnchor.constraint(equalTo: self.photoImage.widthAnchor,
                                                                       multiplier: 1.0)
        NSLayoutConstraint.activate([topConstraint, centerX, centerY, photoAspectRatio])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize {
        let neededWidth = width - 4 * spacing
        let itemWidth = floor(neededWidth / Constants.itemCount)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
