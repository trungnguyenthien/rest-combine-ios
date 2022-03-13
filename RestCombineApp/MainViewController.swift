//
//  ViewController.swift
//  RestCombineApp
//
//  Created by Trung on 12/03/2022.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.$photos.receive(on: RunLoop.main).sink { photos in
            print("Reload data \(photos.count)")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.loadFirst()
    }
}

extension MainViewController {
    class ViewModel {
        let service = ApplicationService(
            photoRepo: PhotoRepositoryImpl(
                client: AlamofireApiClient()
            )
        )
        
        @Published private(set) var photos: [Photo] = []
        private var cancellables: Set<AnyCancellable> = []
        private var nextPageNumber = 0
        
        func loadFirst() {
            nextPageNumber = 0
            doLoadNext(reset: true)
        }
        
        func loadNext() {
            doLoadNext()
        }
        
        private func doLoadNext(reset: Bool = false) {
            if isEndPage { return }
            service.listPhoto(page: nextPageNumber).sink { [weak self] page in
                guard let self = self, let page = page else { return }
                if reset { self.photos.removeAll() }
                
                self.photos += page
                if page.count == 0 {
                    self.nextPageNumber += 1
                } else {
                    self.markAsEndPage()
                }
            }.store(in: &cancellables)
        }
        
        
        private var isEndPage: Bool {
            nextPageNumber == -1
        }
        
        private func markAsEndPage() {
            nextPageNumber = -1
        }
    }
}
