//
//  ContentView.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "music.note")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("This is a change by J")
                .font(.largeTitle)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
