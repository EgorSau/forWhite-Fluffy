//
//  PhotoConstraints.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 17.11.2022.
//

import UIKit

extension PhotosViewController {
    // MARK: - Constraints
    func viewSetup() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Photo Gallery"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                                                style: .plain,
                                                                                target: self,
                                                                                action: #selector(searchAppearance))
        self.navigationController?.navigationBar.isHidden = false
    }
    func setupTextField() {
        self.view.addSubview(textField)
        self.textField.delegate = self
        let textFieldWidth = self.view.frame.width * 0.85
        let top = self.textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -40)
        let left = self.textField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8)
        let height = self.textField.heightAnchor.constraint(equalToConstant: 40)
        let width = self.textField.widthAnchor.constraint(equalToConstant: textFieldWidth)
        NSLayoutConstraint.activate([top,
                                     left,
                                     height,
                                     width
                                    ])
    }
    func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.topConstraint = self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
        self.leftConstraint = self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        self.rightConstraint = self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        self.bottomConstraint = self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([
                                    self.topConstraint,
                                    self.leftConstraint,
                                    self.rightConstraint,
                                    self.bottomConstraint
                                    ].compactMap({$0}))
    }
    func imageSetup() {
        self.view.addSubview(imageView)
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
    func photoLabelSetup() {
        self.view.addSubview(photoLabel)
        let top = self.photoLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20)
        let right = self.photoLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let left = self.photoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        NSLayoutConstraint.activate([
                                    top,
                                    right,
                                    left
                                    ])
    }
    func buttonsSetup() {
        self.view.addSubview(addButton)
        self.view.addSubview(deleteButton)
        // MARK: Add button
        let top = self.addButton.topAnchor.constraint(equalTo: self.photoLabel.bottomAnchor, constant: 20)
        let left = self.addButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                                        constant: BasicSpacing.positive)

        // MARK: Delete button
        let top2 = self.deleteButton.topAnchor.constraint(equalTo: self.photoLabel.bottomAnchor, constant: 20)
        let left2 = self.deleteButton.leftAnchor.constraint(equalTo: self.addButton.rightAnchor,
                                                            constant: BasicSpacing.positive)
        let right = self.deleteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                                             constant: BasicSpacing.negative)
        // MARK: Width calculation
        let screenWidth = CGFloat(self.view.frame.width)
        let buttonsWidth = (screenWidth - BasicSpacing.positive * 3)/2
        let width = self.addButton.widthAnchor.constraint(equalToConstant: buttonsWidth)
        let width2 = self.deleteButton.widthAnchor.constraint(equalToConstant: buttonsWidth)
        NSLayoutConstraint.activate([
                                    top,
                                    top2,
                                    right,
                                    left,
                                    left2,
                                    width,
                                    width2
                                    ])
    }
    func exitSetup() {
        self.view.addSubview(exitImageView)
        let top = self.exitImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let right = self.exitImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let height = self.exitImageView.heightAnchor.constraint(equalToConstant: 40)
        let width = self.exitImageView.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([top,
                                     right,
                                     height,
                                     width
                                    ])
    }
    @objc private func searchAppearance() {
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.searchDisappearance))
            self.navigationItem.title = ""
            self.textField.becomeFirstResponder()
            self.textField.isHidden = false
            self.textField.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }
    @objc private func searchDisappearance() {
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.textField.alpha = 0
            self.textField.isHidden = true
            self.textField.resignFirstResponder()
            self.navigationItem.title = "Photo Gallery"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.searchAppearance))
            self.view.layoutIfNeeded()
        }
    }
}
