//
//  API.swift
//  CurrentLocation
//
//  Created by Federico on 19/05/2022.
//

import Foundation

enum APIError: Error {
    case invalidRequest
    case invalidURL
}

func getData<T: Decodable>(url: String, model: T.Type, completion:@escaping(Result<T, Error>) -> ()) {
    guard let url = URL(string: url) else {
        completion(.failure(APIError.invalidURL))
        return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            if let error = error { completion(.failure(error)) }
            return }
        
        do {
            let serverData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(serverData))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
