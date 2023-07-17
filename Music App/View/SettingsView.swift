//
//  SettingsView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/17/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {

        VStack(alignment: .leading) {

            Text("SettingsView")

        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {

                Image(systemName: "info.circle")
                    .foregroundColor(Color.purple)
                    .font(.headline)


                    .padding()

            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
