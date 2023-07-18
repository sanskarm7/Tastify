//
//  SongView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/17/23.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct SongView: View {
    
    @EnvironmentObject var spotify: Spotify
    
    @State private var playRequestCancellable: AnyCancellable? = nil
    @State private var loadImageCancellable: AnyCancellable? = nil

    @State private var alert: AlertItem? = nil
    
    @State private var image = Image(systemName: "arrow.triangle.2.circlepath")

    
    //Pass in Track Here
    let track: Track
    
    var body: some View {
        Button(action: playTrack) {
            
            HStack{
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    
                
                VStack(alignment: .leading){
                    Text(track.name.count >= 25 ? String(track.name.prefix(25) + "...") : track.name)
                        .font(
                            Font.custom("Inter", size: 18).weight(.semibold)
                        )
                        
                    if let artistName = track.artists?.first?.name {
                        Text(artistName)
                            .font(
                                Font.custom("Inter", size: 18).weight(.light)
                                )
                    }
                }
                Spacer()
                Image(systemName: "cursorarrow.click.2")
            }
            
        }
        .onAppear{
            loadImage()
        }
        .buttonStyle(.plain)
        .alert(item: $alert) { alert in
            Alert(title: alert.title, message: alert.message)
        }
    }
    
    func playTrack() {
        
        let alertTitle = "Couldn't Play \(track.name)"

        guard let trackURI = track.uri else {
            self.alert = AlertItem(
                title: alertTitle,
                message: "missing URI"
            )
            return
        }

        let playbackRequest: PlaybackRequest

        if let albumURI = track.album?.uri {
            // Play the track in the context of its album. Always prefer
            // providing a context; otherwise, the back and forwards buttons may
            // not work.
            playbackRequest = PlaybackRequest(
                context: .contextURI(albumURI),
                offset: .uri(trackURI)
            )
        }
        else {
            playbackRequest = PlaybackRequest(trackURI)
        }
        
        // By using a single cancellable rather than a collection of
        // cancellables, the previous request always gets cancelled when a new
        // request to play a track is made.
        self.playRequestCancellable = 
            self.spotify.api.getAvailableDeviceThenPlay(playbackRequest)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        
                        print("Error: \(error)")
                    }
                })
        
    }
    
    func loadImage() {
        guard let spotifyImage = track.album?.images?.first else {
            // print("no image found for '\(playlist.name)'")
            return
        }

        
        // Note that a `Set<AnyCancellable>` is NOT being used so that each time
        // a request to load the image is made, the previous cancellable
        // assigned to `loadImageCancellable` is deallocated, which cancels the
        // publisher.
        self.loadImageCancellable = spotifyImage.load()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { image in
                    // print("received image for '\(playlist.name)'")
                    self.image = image
                }
            )
    }
}

struct SongView_Previews: PreviewProvider {
    static let tracks: [Track] = []
    
    static var previews: some View {
        List(tracks, id: \.id) { track in
            SongView(track: track)
        }
        .environmentObject(Spotify())
    }
}

