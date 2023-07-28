//  AudioVisualizer.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/21/23.
//

import SwiftUI

struct AudioVisualizer: View {
    @State private var drawingHeight = true
    
    @State var isPlaying: Bool

    var animation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }

    var body: some View {
        
        if isPlaying{
            HStack {
                HStack {
                    bar(low: 0.4)
                        .animation(animation.speed(1.5), value: drawingHeight)
                    bar(low: 0.3)
                        .animation(animation.speed(1.2), value: drawingHeight)
                    bar(low: 0.5)
                        .animation(animation.speed(1.0), value: drawingHeight)
                    bar(low: 0.3)
                        .animation(animation.speed(1.7), value: drawingHeight)
                }.frame(width: 50)
            }
            .frame(width: 40)
            .onAppear{
                drawingHeight.toggle()
            }
        }
        else{
            HStack {
                HStack {
                    bar(low: 0.2, high: 0.2)
                        .animation(animation.speed(0), value: drawingHeight)
                    bar(low: 0.2, high: 0.2)
                        .animation(animation.speed(0), value: drawingHeight)
                    bar(low: 0.2, high: 0.2)
                        .animation(animation.speed(0), value: drawingHeight)
                    bar(low: 0.2, high: 0.2)
                        .animation(animation.speed(0.5), value: drawingHeight)
                }.frame(width: 50)
            }
            .frame(width: 40)
            .onAppear{
                drawingHeight.toggle()
            }
        }
        

    }

    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.white)
            .frame(height: (drawingHeight ? high : low) * 50)
            .frame(height: 50, alignment: .bottom)
    }
}




//struct AudioVisualizer_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioVisualizer()
//    }
//}
