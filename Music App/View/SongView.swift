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
    
    @State private var image = Image("Spotify Album Placeholder")
    @State private var backgroundColor: Color = .clear


    
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
        .background(backgroundColor)
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

        self.loadImageCancellable = spotifyImage.load()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { image in
                    // print("received image for '\(playlist.name)'")
                    self.image = image
                    self.setAverageColor()
                }
            )
    }
    
     func setAverageColor() {
        let image: Image = self.image // Create an Image anyhow you want
        let uiImage: UIImage = image.asUIImage() // Works Perfectly
        
         let uiColor = uiImage.averageColor ?? .darkGray
        
    //    let uiColor = UIImage(named: images[currentIndex])?.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        scene?.windows.first?.rootViewController?.view.addSubview(controller.view)
//        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var averageColor: UIColor? {
        // convert our image to a Core Image Image
        
        guard let inputImage = CIImage(image: self) else { return nil }
        print("Did run")
        // Create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
        guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert our bitmap images of r, g, b, a to a UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
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

