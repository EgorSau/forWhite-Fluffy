//
//  TabBarController.swift
//  forWhite&Fluffy
//
//  Created by Egor SAUSHKIN on 03.09.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enum Index {
            case none
            case first
            case second
            
            var title: String? {
                switch self {
                case .none:
                    return nil
                case .first:
                    return "Collection"
                case .second:
                    return "Table"
                }
            }
            var image: String {
                switch self {
                case .none:
                    return ""
                case .first:
                    return "square.grid.2x2"
                case .second:
                    return "tablecells"
                }
            }
        }

        var arrayVC: [UIViewController] = [TableViewController(), PhotosViewController()]
        
        arrayVC[0] = UINavigationController(rootViewController: PhotosViewController())
        arrayVC[1] = UINavigationController(rootViewController: TableViewController())
        
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
                viewController.tabBarItem.image = UIImage (systemName: Index.second.image)
                viewController.tabBarItem.title = Index.second.title
            default:
                viewController.tabBarItem.title = Index.none.title
            }
        })
    }
}

