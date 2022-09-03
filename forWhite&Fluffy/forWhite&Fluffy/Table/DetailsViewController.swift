//
//  DetailsViewController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class DetailsViewController: UIViewController{
    
    var imagesArray = [UIImage]()
    var stringsArray = [String]()
    var indexPath: IndexPath = [0, 0]
    var image = UIImage()
    var text: String = ""
    
    private lazy var photoLabel: UILabel = {
        var photoLabel = UILabel()
        photoLabel.numberOfLines = 3
        photoLabel.lineBreakStrategy = .pushOut
        photoLabel.backgroundColor = .systemBlue
        photoLabel.textColor = .white
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        return photoLabel
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        self.imageSetup()
        self.photoLabelSetup()

    }
    
    private func viewSetup(){
        self.view.backgroundColor = .white
    }
    
    private func imageSetup(){
        self.view.addSubview(imageView)
        self.imageView.image = self.image

        let top = self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height/6)
        let right = self.imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let left = self.imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let imageViewAspectRatio = self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0)

        NSLayoutConstraint.activate([
                                    top,
                                    imageViewAspectRatio,
                                    right,
                                    left
                                    ])
    }
    
    private func photoLabelSetup(){
        self.view.addSubview(photoLabel)
        self.photoLabel.text = self.text

        let top = self.photoLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20)
        let right = self.photoLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let left = self.photoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor)

        NSLayoutConstraint.activate([
                                    top,
                                    right,
                                    left
                                    ])
    }
    
    @objc func getDataFromTableViewController(notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        guard let authors = userInfo["authors"] as? [String] else { return }
        guard let images = userInfo["images"] as? [UIImage] else { return }
        self.imageView.image = images[self.indexPath.row]
        self.photoLabel.text = authors[self.indexPath.row]
    }
    
}
