//
//  router.swift
//  RestCombineApp
//
//  Created by Trung on 13/03/2022.
//

import Foundation
import UIKit

enum RouteTarget {
    case login
    case detail(id: String)
    case web(url: String, title: String?)
}

func makeViewController(target: RouteTarget) -> UIViewController {
    switch(target) {
    case .detail: return DetailViewController()
    case .login: return UIViewController()
    case .web: return UIViewController()
    }
}
