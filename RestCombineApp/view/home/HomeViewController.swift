//
//  HomeViewController.swift
//  RestCombineApp
//
//  Created by Trung on 14/03/2022.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    var viewModel: ViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.$photos.receive(on: RunLoop.main).sink { photos in
            print("Reload data \(photos.count)")
        }.store(in: &cancellables)
        
        viewModel.$isLoading.receive(on: RunLoop.main).sink { isLoading in
            print("Is Loading \(isLoading)")
        }.store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.loadFirst()
    }
}

