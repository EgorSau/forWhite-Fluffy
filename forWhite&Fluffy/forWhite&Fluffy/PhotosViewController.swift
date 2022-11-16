//
//  PhotosViewController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class PhotosViewController: UIViewController, UITextFieldDelegate {
    var isExpanded = false
    let exitTapGesture = UITapGestureRecognizer()
    var topConstraint: NSLayoutConstraint?
    var leftConstraint: NSLayoutConstraint?
    var rightConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var favorite = ""
    let defaults = UserDefaults.standard
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.isHidden = true
        textField.alpha = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.tintColor = UIColor.systemBlue
        textField.autocapitalizationType = .sentences
        textField.placeholder = " Search"
        return textField
    }()
    lazy var addButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Add to Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
        button.layer.cornerRadius = 8
        button.titleLabel?.text = ""
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(.none, action: #selector(addToFavorites), for: .touchUpInside)
        return button
    }()
    lazy var deleteButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Delete from Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
        button.isEnabled = false
        button.layer.cornerRadius = 8
        button.titleLabel?.text = ""
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(.none, action: #selector(deleteFromFavorites), for: .touchUpInside)
        return button
    }()
    lazy var photoLabel: UILabel = {
        var photoLabel = UILabel()
        photoLabel.numberOfLines = 3
        photoLabel.lineBreakStrategy = .pushOut
        photoLabel.isHidden = true
        photoLabel.backgroundColor = .systemBlue
        photoLabel.textColor = .white
        photoLabel.alpha = 0
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        return photoLabel
    }()
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var exitImageView: UIImageView = {
        var exitImageView = UIImageView()
        let exitImage = UIImage(systemName: "xmark.circle.fill")
        exitImageView.image = exitImage
        exitImageView.tintColor = .black
        exitImageView.layer.masksToBounds = true
        exitImageView.isUserInteractionEnabled = true
        exitImageView.alpha = 0
        exitImageView.isHidden = true
        exitImageView.translatesAutoresizingMaskIntoConstraints = false
        return exitImageView
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPosts()
        self.setupExitGesture()
        self.setupCollectionView()
        self.viewSetup()
        self.imageSetup()
        self.exitSetup()
        self.setupTextField()
        self.photoLabelSetup()
        self.buttonsSetup()
        self.kbdNotificatorAppearance()
    }
    deinit {
        self.kbdNotificatorRemove()
    }
    // MARK: - Network
    func fetchPosts() {
        DispatchQueue.global(qos: .utility).async {
            NetworkService().urlRequest { [weak self] posts in
                guard let self = self else { return }
                switch posts {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    var images = [UIImage]()
                    var authors = [String?]()
                    var locations = [String?]()
                    var dates = [String?]()
                    var ids = [String]()
                    try result.forEach { post in
                        self.collectionView.reloadData()
                        guard let pictureName = post.urls.small else { return }
                        guard let url = URL(string: pictureName) else { return }
                        let data = try Data(contentsOf: url, options: [])
                        guard let image = UIImage(data: data) else { return }
                        images.append(image)
                        authors.append(post.user.name)
                        locations.append(post.user.location)
                        dates.append(post.created_at)
                        ids.append(post.id)
                    }
                    PostModel.images = images
                    PostModel.authors = authors
                    PostModel.locations = locations
                    PostModel.dates = dates
                    PostModel.ids = ids
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        do {
            NetworkService().searchRequest(withText: textField.text!) { [weak self] posts in
                guard let self = self else { return }
                switch posts {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    if result.results.isEmpty {
                        self.notFoundAlert()
                    } else {
                        var images = [UIImage]()
                        var authors = [String?]()
                        var locations = [String?]()
                        var dates = [String?]()
                        var ids = [String]()
                        try result.results.forEach { post in
                            self.collectionView.reloadData()
                            guard let pictureName = post.urls.small else { return }
                            guard let url = URL(string: pictureName) else { return }
                            let data = try Data(contentsOf: url, options: [])
                            guard let image = UIImage(data: data) else { return }
                            images.append(image)
                            authors.append(post.user.name)
                            locations.append(post.user.location)
                            dates.append(post.created_at)
                            ids.append(post.id)
                        }
                        PostModel.images = images
                        PostModel.authors = authors
                        PostModel.locations = locations
                        PostModel.dates = dates
                        PostModel.ids = ids
                    }
                }
            }
        }
        return true
    }
    // MARK: - Keyboard
    func kbdNotificatorAppearance() {
        let notifCenter = NotificationCenter.default
        notifCenter.addObserver(self,
                                selector: #selector(self.kbdShow),
                                name: UIResponder.keyboardWillShowNotification,
                                object: nil)
        notifCenter.addObserver(self,
                                selector: #selector(self.kbdHide),
                                name: UIResponder.keyboardWillHideNotification,
                                object: nil)
    }
    func kbdNotificatorRemove() {
        let notifCenter = NotificationCenter.default
        notifCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notifCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.collectionView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                             left: 0,
                                                                             bottom: kbdSize.height,
                                                                             right: 0)
        }
    }
    @objc private func kbdHide(notification: NSNotification) {
            self.collectionView.verticalScrollIndicatorInsets = .zero
    }

    // MARK: - Data
    @objc func deleteFromFavorites() {
        for (index, id) in PostModel.favorites.enumerated() where id == self.favorite {
            PostModel.favorites.remove(at: index)
        }
        self.addButton.alpha = 1
        self.addButton.isEnabled = true
        self.deleteButton.alpha = 0.5
        self.deleteButton.isEnabled = false
        self.collectionView.reloadData()
        self.deletedAlert()
    }
    @objc private func addToFavorites() {
        PostModel.favorites.append(favorite)
        self.defaults.set(PostModel.favorites, forKey: "favorite")
        self.addButton.alpha = 0.5
        self.addButton.isEnabled = false
        self.deleteButton.alpha = 1
        self.deleteButton.isEnabled = true
        self.collectionView.reloadData()
        self.addedAlert()
    }
    // MARK: - Alerts
    private func deletedAlert() {
        let alert = UIAlertController(title: Alert.warningTitle,
                                      message: Alert.warningMessage,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: Alert.actionTitle,
                                   style: .default)
        present(alert, animated: true, completion: .none)
        alert.addAction(action)
    }
    private func notFoundAlert() {
        let alert = UIAlertController(title: Alert.notFoundTitle,
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: Alert.actionTitle,
                                   style: .default)
        present(alert, animated: true, completion: .none)
        alert.addAction(action)
    }
    private func addedAlert() {
        let alert = UIAlertController(title: Alert.greatTitle,
                                      message: Alert.greatMessage,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: Alert.actionTitle,
                                   style: .default)
        present(alert, animated: true, completion: .none)
        alert.addAction(action)
    }
    // MARK: - Gestures
    func imageZoom(forCell: IndexPath) {
        textField.resignFirstResponder()
        self.imageView.image = PostModel.images[forCell.row]
        guard let author = PostModel.authors[forCell.row] else { return }
        guard let date = PostModel.dates[forCell.row] else { return }
        self.favorite = PostModel.ids[forCell.row]
        var newLocations = [String?]()
        for location in PostModel.locations {
            if location == nil {
                newLocations.append("No location")
            } else {
                newLocations.append(location)
            }
        }
        guard let location = newLocations[forCell.row] else { return }
        let viewModel = ViewModel(author: author,
                                  creationDate: date,
                                  location: location)
        self.setup(with: viewModel)
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.imageView.isHidden = false
            self.imageView.alpha = 1
            self.photoLabel.isHidden = false
            self.photoLabel.alpha = 1
            self.addButton.alpha = 1
            self.deleteButton.alpha = 0.5
            if PostModel.favorites.contains(self.favorite) {
                self.deleteButton.alpha = 1
                self.deleteButton.isEnabled = true
                self.addButton.alpha = 0.5
                self.addButton.isEnabled = false
            } else {
                self.deleteButton.alpha = 0.5
                self.deleteButton.isEnabled = false
                self.addButton.alpha = 1
                self.addButton.isEnabled = true
            }
            self.topConstraint?.isActive = false
            self.leftConstraint?.isActive = false
            self.rightConstraint?.isActive = false
            self.bottomConstraint?.isActive = false
            self.exitImageView.isHidden = false
            self.exitImageView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    private func setupExitGesture() {
        self.exitImageView.addGestureRecognizer(self.exitTapGesture)
        self.exitTapGesture.addTarget(self, action: #selector(self.exitHandleTapGesture))
    }
    @objc private func exitHandleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard self.exitTapGesture === gestureRecognizer else { return }
        self.exit()
    }
    private func exit() {
        self.isExpanded.toggle()
        if self.isExpanded {
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                self.imageView.alpha = 0
                self.photoLabel.alpha = 0
                self.addButton.alpha = 0
                self.deleteButton.alpha = 0
                self.exitImageView.alpha = 0
                self.topConstraint?.isActive = true
                self.leftConstraint?.isActive = true
                self.rightConstraint?.isActive = true
                self.bottomConstraint?.isActive = true
                self.view.layoutIfNeeded()
            }
            if textField.isHidden == false {
                self.textField.becomeFirstResponder()
            }
        }
    }
}
