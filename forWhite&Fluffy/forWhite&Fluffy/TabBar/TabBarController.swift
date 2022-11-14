//
//  TabBarController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class TabBarController: UITabBarController {
    enum Index {
        case none
        case first
        case second
        var title: String? {
            switch self {
            case .none:
                return nil
            case .first:
                return "Table"
            case .second:
                return "Collection"
            }
        }
        var image: String {
            switch self {
            case .none:
                return ""
            case .first:
                return "tablecells"
            case .second:
                return "square.grid.2x2"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    private func setupTabBar() {

        var arrayVC: [UIViewController] = [TableViewController(), PhotosViewController()]
        arrayVC[0] = UINavigationController(rootViewController: TableViewController())
        arrayVC[1] = UINavigationController(rootViewController: PhotosViewController())
        self.viewControllers = arrayVC.map({ tabBarItem in
            switch tabBarItem {
            case TableViewController():
                return TableViewController()
            case PhotosViewController():
                return UINavigationController(rootViewController: PhotosViewController())
            default:
                break
            }
            return tabBarItem
        })
        arrayVC.enumerated().forEach({ (index, viewController) in
            switch index {
            case 0:
                viewController.tabBarItem.image = UIImage(systemName: Index.first.image)
                viewController.tabBarItem.title = Index.first.title
            case 1:
                viewController.tabBarItem.image = UIImage(systemName: Index.second.image)
                viewController.tabBarItem.title = Index.second.title
            default:
                viewController.tabBarItem.title = Index.none.title
            }
        })
    }
}
