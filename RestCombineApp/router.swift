//
//  router.swift
//  RestCombineApp
//
//  Created by Trung on 13/03/2022.
//

import Foundation
import UIKit

enum RouteTarget {
    case home
    case detail(id: String)
    case web(url: String, title: String?)
}

func makeViewController(target: RouteTarget) -> UIViewController {
    switch(target) {
    case .detail: return DetailViewController()
    case .home: return createHomeVC()
    case .web: return UIViewController()
    }
}

private func createHomeVC() -> UIViewController {
    container.resolve(HomeViewController.self)!
}
