//
//  PhotosViewController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit
import Alamofire

protocol ViewModelProtocol {}

protocol Setupable {
    func setup(with viewModel: ViewModelProtocol)
}

class PhotosViewController: UIViewController, UITextFieldDelegate {
    
    var isExpanded = false
    let exitTapGestureRecognizer = UITapGestureRecognizer()
    var images = [UIImage]()
    var authors = [String?]()
    var dates = [String?]()
    var locations = [String?]()
    var topConstraint: NSLayoutConstraint?
    var leftConstraint: NSLayoutConstraint?
    var rightConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    let token = "xOZhFXxLD9YKp4qiq7SaLlJzLLs8nHrTCdUtOOQlmAc"
    var searchText: String = ""
    var tempStrArray = [String]()
    var tempImgArray = [UIImage]()
    var dictionary: [String : Any] = ["authors": [String](), "images": [UIImage]()]
    
    struct ViewModel: ViewModelProtocol {
        let author: String
        let creationDate: String
        let location: String
    }
    
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
    
    private lazy var addButton: UIButton = {
        var addButton = UIButton()
        addButton.isHidden = true
        addButton.backgroundColor = .systemGreen
        addButton.setTitle("Add to Favorites", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.alpha = 0
        addButton.layer.cornerRadius = 8
        addButton.titleLabel?.text = ""
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(.none, action: #selector(addToFavorites), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var deleteButton: UIButton = {
        var addButton = UIButton()
        addButton.isHidden = true
        addButton.backgroundColor = .systemRed
        addButton.setTitle("Delete from Favorites", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.alpha = 0
        addButton.layer.cornerRadius = 8
        addButton.titleLabel?.text = ""
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(.none, action: #selector(deleteFromFavorites), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var photoLabel: UILabel = {
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
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var exitImageView: UIImageView = {
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.viewSetup()
        self.imageSetup()
        self.exitSetup()
        self.setupGesture()
        self.setupTextField()
        self.photoLabelSetup()
        self.buttonsSetup()
    }
    
    private func viewSetup(){
        self.view.backgroundColor = .white
    }
    
    private func setupTextField(){
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
    
    private func setupCollectionView(){
        self.navigationItem.title = "Photo Gallery"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                                                style: .plain,
                                                                                target: self,
                                                                                action: #selector(searchAppearance))
        self.navigationController?.navigationBar.isHidden = false
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
    
    private func imageSetup(){
        self.view.addSubview(imageView)

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

        let top = self.photoLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20)
        let right = self.photoLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let left = self.photoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor)

        NSLayoutConstraint.activate([
                                    top,
                                    right,
                                    left
                                    ])
    }
    
    private func buttonsSetup(){
        self.view.addSubview(addButton)
        self.view.addSubview(deleteButton)
        
        enum Constants: CGFloat {
            case positiveBasicSpacing = 8
            case negativeBasicSpacing = -8
        }
        
        //MARK: Add button
        let top = self.addButton.topAnchor.constraint(equalTo: self.photoLabel.bottomAnchor, constant: 20)
        let left = self.addButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Constants.positiveBasicSpacing.rawValue)

        //MARK: Delete button
        let top2 = self.deleteButton.topAnchor.constraint(equalTo: self.photoLabel.bottomAnchor, constant: 20)
        let left2 = self.deleteButton.leftAnchor.constraint(equalTo: self.addButton.rightAnchor, constant: Constants.positiveBasicSpacing.rawValue)
        let right = self.deleteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: Constants.negativeBasicSpacing.rawValue)
        
        //MARK: Width calculation

        let screenWidth = CGFloat(self.view.frame.width)
        let buttonsWidth = (screenWidth - Constants.positiveBasicSpacing.rawValue * 3)/2
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
    
    private func exitSetup(){
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

    @objc private func searchRequest(completion: @escaping ([UIImage]) -> Void){
        let url = URL(string: "https://api.unsplash.com/search/photos?query=\(self.searchText)")
        var request = URLRequest(url: url!)
        request.setValue("Client-ID \(self.token)", forHTTPHeaderField: "Authorization")
        AF.request(request).responseDecodable(of: Results.self) { response in
            guard let value = response.value else { return }
            var imagesArray = [UIImage]()
            for each in value.results {
                //String data
                let author = each.user.name
                let creation_date = each.created_at
                let location = each.user.location
                self.authors.append(author)
                self.dates.append(creation_date)
                self.locations.append(location)
                
                //Pictures data
                guard let pictureName = each.urls.small else { return }
                guard let url = URL(string: pictureName)
                else {
                    print("Unable to create URL")
                    return
                }
                do {
                    let data = try Data(contentsOf: url, options: [])
                    guard let image = UIImage(data: data) else { return }
                    imagesArray.append(image)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            self.collectionView.reloadData()
            completion(imagesArray)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchText = textField.text!
        self.searchRequest{ Pictures in
            self.images = Pictures
        }
        return true
    }

    @objc func deleteFromFavorites(){
        for (index, image) in tempImgArray.enumerated() {
            guard self.imageView.image == image else { return }
            self.tempImgArray.remove(at: index)
            self.tempStrArray.remove(at: index)
            self.dictionary["authors"] = self.tempStrArray
            self.dictionary["images"] = self.tempImgArray
            NotificationCenter.default.post(name: Notification.Name(rawValue: "dataFromCollection"), object: nil, userInfo: self.dictionary)
            self.collectionView.reloadData()
            self.deletedAlert()
        }
    }
    
    @objc func addToFavorites(){
        guard let image = self.imageView.image else { return }
        self.tempImgArray.append(image)
        guard let author = self.photoLabel.text else { return }
        self.tempStrArray.append(author)
        self.dictionary["authors"] = self.tempStrArray
        self.dictionary["images"] = self.tempImgArray
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dataFromCollection"), object: nil, userInfo: self.dictionary)
        self.collectionView.reloadData()
        self.addedAlert()
    }
    
    private func deletedAlert() {
        let alert = UIAlertController(title: "Warning!", message: "This picture was deleted from favorites", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default)
        present(alert, animated: true, completion: .none)
        alert.addAction(action)
    }
    
    private func addedAlert() {
        let alert = UIAlertController(title: "Great!", message: "This picture was added to favorites", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default)
        present(alert, animated: true, completion: .none)
        alert.addAction(action)
    }
    
    func imageZoom(forCell: IndexPath){
        self.imageView.image = self.images[forCell.row]
        guard let author = self.authors[forCell.row] else { return }
        guard let date = self.dates[forCell.row] else { return }
        
        var newLocations = [String?]()
        for location in locations {
            if location == nil {
                newLocations.append("No location")
            } else {
                newLocations.append(location)
            }
        }

        guard let location = newLocations[forCell.row] else { return }
        let viewModel = PhotosViewController.ViewModel(author: author,
                                                       creationDate: date,
                                                       location: location)
        
        self.setup(with: viewModel)
        
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            
            self.imageView.isHidden = false
            self.imageView.alpha = 1
            self.photoLabel.isHidden = false
            self.photoLabel.alpha = 1
            self.addButton.isHidden = false
            self.addButton.alpha = 1
            self.deleteButton.isHidden = false
            self.deleteButton.alpha = 1
            self.topConstraint?.isActive = false
            self.leftConstraint?.isActive = false
            self.rightConstraint?.isActive = false
            self.bottomConstraint?.isActive = false
            
            self.exitImageView.isHidden = false
            self.exitImageView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func setupGesture(){
        self.exitImageView.addGestureRecognizer(self.exitTapGestureRecognizer)
        self.exitTapGestureRecognizer.addTarget(self, action: #selector(self.exitHandleTapGesture))
    }
    
    @objc private func exitHandleTapGesture(_ gestureRecognizer: UITapGestureRecognizer){
        guard self.exitTapGestureRecognizer === gestureRecognizer else { return }
        
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
        }
    }
    
    @objc private func searchAppearance(){
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
    
    @objc private func searchDisappearance(){
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.textField.alpha = 0
            self.textField.isHidden = true
            self.navigationItem.title = "Photo Gallery"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.searchAppearance))
            self.view.layoutIfNeeded()
        }
    }
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
            NetworkService().urlRequest { (pictures, authors, locations, dates) in
                cell.photoImage.image = pictures[indexPath.row]
                self.images = pictures
                self.authors = authors
                self.locations = locations
                self.dates = dates
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

