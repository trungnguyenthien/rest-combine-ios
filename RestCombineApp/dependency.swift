//
//  dependency.swift
//  RestCombineApp
//
//  Created by Trung on 14/03/2022.
//

import Foundation
import Swinject
import UIKit

private let container = Container()

func registerDependency() {
    /// Fix type
    container.register(ApiClient.self) { resolver in AlamofireApiClient() }
    
    ///Auto resolve
    container.register(PhotoRepository.self) { resolver in
        PhotoRepositoryImpl(client: resolver.resolve(ApiClient.self)!)
    }
    container.register(ApplicationService.self) { resolver in
        ApplicationService(photoRepo: resolver.resolve(PhotoRepository.self)!)
    }
    
    container.register(HomeViewController.ViewModel.self) { resolver in
        HomeViewController.ViewModel(service: resolver.resolve(ApplicationService.self)!)
    }
    
    container.register(HomeViewController.self) { resolver in
        let vc = HomeViewController()
        vc.viewModel = resolver.resolve(HomeViewController.ViewModel.self)
        return vc
    }
}

func createMainVC() -> UIViewController {
    container.resolve(HomeViewController.self)!
}
