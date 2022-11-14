//
//  DetailsViewController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    var indexPath: IndexPath = [0, 0]
    var image = UIImage()
    var text: String = ""
//    var isAddedToFavorites: Bool
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
    private lazy var deleteButton: UIButton = {
        var addButton = UIButton()
        addButton.isHidden = false
        addButton.backgroundColor = .systemRed
        addButton.setTitle("Delete from Favorites", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.alpha = 1
        addButton.layer.cornerRadius = 8
        addButton.titleLabel?.text = ""
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(.none, action: #selector(deleteFromFavorites), for: .touchUpInside)
        return addButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        self.imageSetup()
        self.photoLabelSetup()
        self.setupDeleteButtonConstraints()
    }
//    init? (_ coder: NSCoder, notification: Notification) {
//    init? (image: UIImage, text: String) {
//        super.init(coder: NSCoder())
//        guard let userInfo = notification.userInfo else { return }
//        guard let authors = userInfo["authors"] as? [String] else { return }
//        guard let images = userInfo["images"] as? [UIImage] else { return }
//        self.imageView.image = image
//        self.photoLabel.text = text
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    private func viewSetup() {
        self.view.backgroundColor = .white
    }
    private func imageSetup() {
        self.view.addSubview(imageView)
        self.imageView.image = self.image

        let top = self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height/6)
        let right = self.imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let left = self.imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let imageViewAspectRatio = self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor,
                                                                          multiplier: 1.0)

        NSLayoutConstraint.activate([
                                    top,
                                    imageViewAspectRatio,
                                    right,
                                    left
                                    ])
    }
    private func photoLabelSetup() {
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
    private func setupDeleteButtonConstraints() {
        self.view.addSubview(deleteButton)
        let top = self.deleteButton.topAnchor.constraint(equalTo: self.photoLabel.bottomAnchor, constant: 20)
        let left = self.deleteButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                                           constant: BasicSpacing.positive.rawValue)
        let right = self.deleteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                                             constant: BasicSpacing.negative.rawValue)
        let height = self.deleteButton.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
                                    top,
                                    right,
                                    left,
                                    height
                                    ])
    }
    @objc func getDataFromTableViewController(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let authors = userInfo["authors"] as? [String] else { return }
        guard let images = userInfo["images"] as? [UIImage] else { return }
        self.imageView.image = images[self.indexPath.row]
        self.photoLabel.text = authors[self.indexPath.row]
    }
    @objc func deleteFromFavorites() {
        let tableVC = TableViewController()
//        navigationController?.pushViewController(tableVC, animated: true)
        navigationController?.popToRootViewController(animated: true)
        tableVC.deleteFromDetailedVC(indexPath)
//        print(indexPath)
//        indexPath.row
        /*
         var indexPath: IndexPath = [0, 0]
         var image = UIImage()
         var text: String = ""
         */
//        for (index, image) in photosVC.tempImgArray.enumerated(){
//            
//        }
//        for (index, image) in tempImgArray.enumerated() {
//            guard self.imageView.image == image else { return }
//            self.tempImgArray.remove(at: index)
//            self.tempStrArray.remove(at: index)
//            self.dictionary["authors"] = self.tempStrArray
//            self.dictionary["images"] = self.tempImgArray
//            NotificationCenter.default.post(name: Notification.Name.dataFromCollection,
//                                            object: nil,
//                                            userInfo: self.dictionary)
//            self.addButton.isHidden = false
//            self.addButton.alpha = 1
//            self.deleteButton.isHidden = true
//            self.deleteButton.alpha = 0
//            self.collectionView.reloadData()
//            self.deletedAlert()
//        }
    }
}
