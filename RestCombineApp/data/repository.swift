//
//  repository.swift
//  RestCombineApp
//
//  Created by Trung on 13/03/2022.
//

import Foundation
import Combine

protocol PhotoRepository {
    func list(page: Int) -> AnyPublisher<[Photo]?, Never>
}

class PhotoRepositoryImpl: PhotoRepository {
    private let client: ApiClient
    init(client: ApiClient) {
        self.client = client
    }
    
    private var defaultListRequest: RestRequest {
        .init(
           method: .get,
           baseUrl: "https://picsum.photos",
           endPoint: "v2/list",
           defaultQueries: ["limit": 100]
       )
    }
    
    func list(page: Int) -> AnyPublisher<[Photo]?, Never> {
        let request = defaultListRequest.appendingQueries(["page": page])
        
        return client.send(request: request)
            .map { parsing($0.data, to: [Photo].self) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

struct Photo: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
