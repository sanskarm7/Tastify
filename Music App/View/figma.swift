//
//  figma.swift
//  Music App
//
//  Created by Jay Sunkara on 7/14/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore




struct figma: View {

    var body: some View {
        
        NavigationView {
                
            ZStack{
                Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {

                    Text("text")

                }
            }
                
        
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {

                        NavigationLink(destination: SettingsView()) {
                            Image("gearshape")
                                .font(.headline)
                        }

                    }
                }
            
                
            }
            
            
               
                
        
    }
}

struct figma_Previews: PreviewProvider {
    static var previews: some View {
        figma()
    }
}
