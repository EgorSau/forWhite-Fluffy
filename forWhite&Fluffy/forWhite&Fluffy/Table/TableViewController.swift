//
//  TableViewController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class TableViewController: UIViewController {
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
    func pushToPhotoCollection(indexPath: IndexPath) {
        let path = PostModel.favoritesPath[indexPath.row]
        guard let author = PostModel.authors[path] else { return }
        guard let date = PostModel.dates[path] else { return }
        var newLocations = [String?]()
        for location in PostModel.locations {
            if location == nil {
                newLocations.append("No location")
            } else {
                newLocations.append(location)
            }
        }
        guard let location = newLocations[path] else { return }
        let text = "Author: \(author)\nCreation date: \(date)\nLocation: \(location)"
        let detailsVC = DetailsViewController(image: PostModel.images[path],
                                              text: text)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostModel.favorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotosTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        if PostModel.favorites.isEmpty == false {
            let favorite = PostModel.favorites[indexPath.row]
            PostModel.ids.enumerated().forEach { index, id in
                if id == favorite {
                    cell.imageView?.image = PostModel.images[index]
                    cell.textLabel?.text = PostModel.authors[index]
                    if PostModel.favoritesPath.contains(index) {
                        
                    } else {
                        PostModel.favoritesPath.append(index)
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToPhotoCollection(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            PostModel.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
