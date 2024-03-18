#  AstroPix

AstroPix is an iOS app that provides users with a daily picture of the cosmos, sourced from NASA's Astronomy Picture of the Day (APOD) API.

## Overview

AstroPix allows users to view captivating images of space, along with informative descriptions provided by NASA. Users can explore images from past dates and discover the wonders of the universe right from their iOS device.

## Showcase

<img src="readme_resources/Simulator Screen Recording - iPhone 15 Pro - 2024-03-18 at 10.10.56.gif" alt="Showcase" width="150"> <img src="readme_resources/Simulator Screenshot - iPhone 15 Pro - 2024-03-18 at 09.58.19.png" alt="Screenshot 1" width="150"> <img src="readme_resources/Simulator Screenshot - iPhone 15 Pro - 2024-03-18 at 09.58.44.png" alt="Screenshot 2" width="150"> 

## Usage

To explore AstroPix on your iOS device or simulator:

- Clone the repository to your local machine.
- Open the project in Xcode.
- Build and run the project on your device or simulator.

## Technologies Used

- SwiftUI
- Swift
- Swift Concurrency
- JSON
- URL Session
- MVVM


# Code info

How I solved coding problems and how I used technologies.

## URL Session with Swift concurrency

### NetworkManager.swift

I have used swift concurrency with URL Session in method, that is async and can throw, to handle errors in View Model. I have used @escaping function to send downloaded and Decoded data. I have used .convertFromSnakeCase decode strategy to convert to swift naming style.

```swift
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
```

## APOD Model

```swift
struct Apod: Codable {
    let copyright: String?
    let explanation: String
    let url: String
    let title: String
    let mediaType: String
}
```

## View model and publishing changes in main thread

In escaping function I have to use DispatchQueue to publish data into view. I have used weak refernece inside the completetion handler. 

```swift
try await manager.downloadData(for: date) { [weak self] data in
    DispatchQueue.main.async {
        self?.apod = data
    }
}
```


# Future Enhancement

Things I can add or change in the future

- Showing videoplayer instead of Link button
- Creating calendar view to switch to specific date
- Add cache to save data for offline use
