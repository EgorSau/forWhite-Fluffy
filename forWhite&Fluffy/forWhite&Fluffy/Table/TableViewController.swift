//
//  TableViewController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class TableViewController: UIViewController {
    
    var imagesArray = [UIImage]()
    var stringsArray = [String]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotoCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Favorites"
        NotificationCenter.default.addObserver(self, selector: #selector(getDataFromPhotoViewController), name: Notification.Name(rawValue: "dataFromCollection"), object: nil)
        self.view.addSubview(self.tableView)
        
        let topConstraint = self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leadingConstraint = self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     bottomConstraint
                                    ])
    }

    @objc func getDataFromPhotoViewController(notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        guard let authors = userInfo["authors"] as? [String] else { return }
        guard let images = userInfo["images"] as? [UIImage] else { return }
        self.stringsArray = authors
        self.imagesArray = images
    }
    
    func pushToPhotoCollection(indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        navigationController?.pushViewController(detailsVC, animated: true)
        detailsVC.indexPath = indexPath
        detailsVC.image = self.imagesArray[indexPath.row]
        detailsVC.text = self.stringsArray[indexPath.row]
    }

}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stringsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotosTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        
        if self.stringsArray.isEmpty == false || self.imagesArray.isEmpty == false {
            cell.textLabel?.text = self.stringsArray[indexPath.row]
            cell.imageView?.image = self.imagesArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToPhotoCollection(indexPath: indexPath)
    }
}

