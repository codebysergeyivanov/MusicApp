//
//  LibraryView.swift
//  MusicApp
//
//  Created by Сергей Иванов on 11.01.2021.
//

import SwiftUI
import URLImage

struct TrackRaw: View {
    var track: Track
    var body: some View {
        HStack {
            URLImage(url: URL(string: track.imageUrl ?? "")!,
                     content: { image in
                         image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                     })
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(track.trackName)
                Text(track.artistName)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
            }
            Spacer()
        }
    }
}

struct LibraryView: View {
    @State private var addedTracks = { () -> [Track] in
        let userDefaults = UserDefaults.standard
        do {
            let response = try userDefaults.getObject(forKey: "tracks", castTo: SearchResponse.self)
            return response.results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }()
    @State private var track: Track!
    @State private var selectedRaw = 0
    var trackViewDelegate: TrackViewDelegate?
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack(spacing: 10) {
                    Button(action: {
                        self.track = addedTracks[0]
                        trackViewDelegate?.maxSizeTrackView(viewModel: self.track)
                        let tabBarVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? TabBarViewController
                        tabBarVC?.trackView.delegate = self
                    }) {
                        Image(systemName: "play.fill")
                        Text("Play")
                    }
                    .padding(.vertical, 8)
                    .frame(minWidth: UIScreen.main.bounds.width / 2 - 20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.purple, lineWidth: 1))
                    .foregroundColor(Color.purple)

                    Button(action: {
                        let userDefaults = UserDefaults.standard
                        do {
                            let response = try userDefaults.getObject(forKey: "tracks", castTo: SearchResponse.self)
                            self.addedTracks = response.results
                        } catch {
                            print(error.localizedDescription)
                        }
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        Text("Refresh")
                    }
                    .frame(minWidth: UIScreen.main.bounds.width / 2 - 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.purple, lineWidth: 1))
                    .foregroundColor(Color.purple)
                }
                Divider().padding(.horizontal, 20)
                List {
                    ForEach(addedTracks) {
                        track in
                        TrackRaw(track: track)
                            .gesture(
                                TapGesture()
                                    .onEnded() {
                                        self.track = track
                                        trackViewDelegate?.maxSizeTrackView(viewModel: track)
                                        let tabBarVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? TabBarViewController
                                        tabBarVC?.trackView.delegate = self
                                    }
                            )
                    }
                    .onDelete(perform: delete)
                }.listStyle(PlainListStyle())
            }
            .navigationBarTitle("Library")
        }
    }
    
    func delete(at offsets: IndexSet ) {
        addedTracks.remove(atOffsets: offsets)
        
        let userDefaults = UserDefaults.standard
        
        let searchResponse = SearchResponse(resultCount: addedTracks.count, results: addedTracks)
        
        do {
            try userDefaults.setObject(searchResponse, forKey: "tracks")
            print("The track has saved successfully")
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension LibraryView: SwitchTrackDelegate {
    func playNextTrack() -> Track? {
        let index = addedTracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: Track
        if myIndex + 1 == addedTracks.count {
            nextTrack = addedTracks[0]
        } else {
            nextTrack = addedTracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func playPreviousTrack() -> Track? {
        return nil
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
