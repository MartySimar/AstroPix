//
//  ImageOfDay.swift
//  AstroPix
//
//  Created by Martin Šimar on 16.03.2024.
//

import Foundation

struct Apod: Codable {
    let copyright: String?
    let explanation: String
    let url: String
    let title: String
    let mediaType: String
}
