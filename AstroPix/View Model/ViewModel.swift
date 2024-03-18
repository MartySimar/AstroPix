//
//  ViewModel.swift
//  AstroPix
//
//  Created by Martin Šimar on 17.03.2024.
//

import Foundation
import UIKit

@MainActor
final class ViewModel: ObservableObject {
    let manager = NetworkManager()
    @Published var date = Date().withoutTime()
    @Published var apod: Apod?
    @Published var image: UIImage?
    @Published var isTomorrowValid = false
    
    func downloadApod() async {
        do {
            try await manager.downloadData(for: date) { [weak self] data in
                DispatchQueue.main.async {
                    self?.apod = data
                }
            }
            if apod?.mediaType == StringKeys.image.rawValue {
                try await manager.downloadImage(withURL: apod?.url ?? "") { image in
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkTomorrow() {
        if self.date.tomorrow() < Date().withoutTime().tomorrow() {
            self.isTomorrowValid = true
        } else {
            self.isTomorrowValid = false
        }
    }
}
