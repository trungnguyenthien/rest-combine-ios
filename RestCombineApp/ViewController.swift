//
//  ViewController.swift
//  RestCombineApp
//
//  Created by Trung on 12/03/2022.
//

import UIKit
import Combine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let request1 = requestPhoto(page: 1)
        let request2 = requestPhoto(page: 2)
        
        let zipProducer = Publishers.Zip(request1, request2)
            .map { page1, page2 -> [Photo] in
                var output = [Photo]()
                let page1 = page1 ?? []
                let page2 = page2 ?? []
                output.append(contentsOf: page1)
                output.append(contentsOf: page2)
                return output
            }.eraseToAnyPublisher()
        
        zipProducer.sink { all in
            print(all)
        }
    }
    
    private func requestPhoto(page: Int) -> AnyPublisher<[Photo]?, Never>{
        var request = RestRequest()
        request.baseUrl = "https://picsum.photos"
        request.endPoint = "v2/list"
        request.queries = [
            "page": page,
            "limit": 100
        ]
        return send(request: request)
            .map { parseToPhotos(data: $0.data) }
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

func parseToPhotos(data: Data?) -> [Photo]? {
    guard let data = data else { return nil }
    let decoder = JSONDecoder()
    return try? decoder.decode([Photo].self, from: data)
}