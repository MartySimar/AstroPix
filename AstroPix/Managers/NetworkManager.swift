//
//  NetworkManager.swift
//  AstroPix
//
//  Created by Martin Šimar on 16.03.2024.
//

import Foundation
import UIKit

final class NetworkManager {
    func downloadData(for date: Date, completetion: @escaping (_ data: Apod) -> Void) async throws {
        
        let dateString = date.string(format: StringKeys.yyyyMMdd.rawValue)
        guard let url = URL(
            string: "https://api.nasa.gov/planetary/apod?api_key=\(StringKeys.apiKey.rawValue)&date=\(dateString)"
        ) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(Apod.self, from: data)
        
        completetion(decodedData)
    }
    
    func downloadImage(withURL: String, completetion: @escaping (_ image: UIImage?) -> Void) async throws {
        guard let url = URL(string: withURL) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let image = UIImage(data: data)
        completetion(image)
    }
}
