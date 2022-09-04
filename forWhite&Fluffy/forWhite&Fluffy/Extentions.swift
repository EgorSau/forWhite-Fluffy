//
//  Extentions.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 04.09.2022.
//

import UIKit

protocol ViewModelProtocol {}

protocol Setupable {
    func setup(with viewModel: ViewModelProtocol)
}

extension NSNotification.Name {
    static let dataFromCollection = NSNotification.Name("dataFromCollection")
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.backgroundColor = .systemBlue

        if self.images.isEmpty {
            DispatchQueue.global(qos: .utility).async {
                NetworkService().urlRequest { (pictures, authors, locations, dates) in
                    cell.photoImage.image = pictures[indexPath.row]
                    self.images = pictures
                    self.authors = authors
                    self.locations = locations
                    self.dates = dates
                }
            }
        } else {
            cell.photoImage.image = self.images[indexPath.row]
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
        let collection = PhotosCollectionViewCell()
        return collection.itemSize(for: collectionView.frame.width, with: spacing ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? PhotosCollectionViewCell else {return}
        self.imageZoom(forCell: indexPath)
    }
}


extension PhotosViewController: Setupable {
    
    func setup(with viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? ViewModel else { return }
        //MARK: To check how to make text from next line
        self.photoLabel.text = "Author: \(viewModel.author)\nCreation date: \(viewModel.creationDate)\nLocation: \(viewModel.location)"
    }
}

