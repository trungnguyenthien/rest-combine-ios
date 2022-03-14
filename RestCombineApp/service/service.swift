//
//  service.swift
//  RestCombineApp
//
//  Created by Trung on 13/03/2022.
//
import Combine
import Foundation

class ApplicationService {
    private let photoRepo: PhotoRepository
    
    init(photoRepo: PhotoRepository) {
        self.photoRepo = photoRepo
    }
    
    func listPhoto(page: Int) -> AnyPublisher<[Photo]?, Never> {
        photoRepo.list(page: page).map { photos in
            photos?.filter { Double($0.width) >= Double($0.height) * 1.5 }
        }.eraseToAnyPublisher()
    }
}
