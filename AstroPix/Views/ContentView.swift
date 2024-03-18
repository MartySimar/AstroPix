//
//  ContentView.swift
//  AstroPix
//
//  Created by Martin Šimar on 13.03.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            background
            VStack {
                title
                infoCard
                Spacer()
                navigation
            }
        }
        .task {
            await viewModel.downloadApod()
        }
    }
}

extension ContentView {
    private var background: some View {
        Image(.background)
            .resizable()
            .ignoresSafeArea()
    }
    
    private var title: some View {
        HStack {
            Image(.nasa)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 64, alignment: .leading)
            Text("Picture of the day")
                .foregroundStyle(.white)
                .font(.largeTitle)
                .bold()
        }
    }
    
    private var infoCard: some View {
        VStack {
            if let apod = viewModel.apod {
                Text(viewModel.date.string(
                    format: StringKeys.ddMMMyyyy.rawValue
                ))
                Text(apod.title)
                    .font(.title)
                    .foregroundStyle(.white)
                    .bold()
                    .shadow(color: .blue, radius: 8, x: -2, y: -2)
                if let image = viewModel.image {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(maxHeight: 256)
                            .layoutPriority(2)
                        if let copyright = apod.copyright {
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("©\(copyright)")
                                    .foregroundStyle(.secondary)
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                } else if apod.mediaType == StringKeys.video.rawValue {
                    if let url = URL(string: apod.url) {
                        Link(destination: url) {
                            Label("View on YouTube", systemImage: "play.fill")
                                .foregroundStyle(.white)
                                .padding()
                                .background {
                                    Capsule(style: .continuous)
                                        .fill(.red)
                                }
                        }
                        .frame(maxHeight: 256)
                    }
                } else {
                    ProgressView()
                        .frame(maxHeight: 256)
                }
                
                ScrollView {
                    Text(apod.explanation)
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
                .frame(maxHeight: 256)
                .padding(.top)
            } else {
                ProgressView()
                    .frame(maxHeight: .infinity)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 256, alignment: .top)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
        .animation(.easeInOut, value: viewModel.date)
    }
    
    private var navigation: some View {
        HStack {
            Button(action: {
                Task {
                    await MainActor.run {
                        viewModel.date = viewModel.date.yesterday()
                        viewModel.apod = nil
                        viewModel.image = nil
                    }
                    await viewModel.downloadApod()
                }
            }, label: {
                Label(
                    viewModel.date.yesterday().string(format: StringKeys.ddMMMyyyy.rawValue),
                    systemImage: "chevron.left"
                )
                .foregroundStyle(.white)
            })
            
            Spacer()
            
            if viewModel.isTomorrowValid {
                Button(action: {
                    Task {
                        await MainActor.run {
                            viewModel.date = viewModel.date.tomorrow()
                            viewModel.apod = nil
                            viewModel.image = nil
                        }
                        await viewModel.downloadApod()
                    }
                }, label: {
                    HStack {
                        Text(viewModel.date.tomorrow().string(format: StringKeys.ddMMMyyyy.rawValue))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.white)
                })
            }
        }.padding()
            .onChange(of: viewModel.date) {
                viewModel.checkTomorrow()
            }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
