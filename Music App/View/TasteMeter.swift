//
//  TasteMeter.swift
//  Music App
//
//  Created by Sanskar Mishra on 8/3/23.
//

import SwiftUI

struct TasteMeter: View {
    
    @State var isProfile: Bool = true
    
    @State var value: CGFloat = 100
    @State var width: CGFloat = 330
    @State var height: CGFloat = 15
    
    @State var color1: Color = Color.green
    @State var color2: Color = Color.blue
    
    let RED: Color = Color(red: 0.9, green: 0.21, blue: 0.21)
    let ORANGE: Color = Color(red: 0.89, green: 0.41, blue: 0.2)
    let YELLOW: Color = Color(red: 0.88, green: 0.89, blue: 0.2)
    let GREEN: Color = Color(red: 0, green: 0.9, blue: 0.14)
    
    
    var body: some View {
        
        ZStack {
            
            let multiplier = width / 100
            
            
            
            VStack{
                
                if isProfile{
                    //MARK: Meter Label
                    ZStack {
                        
                       
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 98, height: 24)
                          .background(Color(red: 0.16, green: 0.04, blue: 0.49))
                          .cornerRadius(20, corners: [.topLeft, .topRight])

                        
                        Text("Taste Meter")
                          .font(Font.custom("Inter", size: 12))
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color.white)
                    }
                    .frame(width: 98, height: 0)
                }
                
                //MARK: Meter
                ZStack{
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 340, height: 25)
                    .background(Color(red: 0.16, green: 0.04, blue: 0.49))
                    .cornerRadius(20)
                    
                    
                    //MARK: Progress Bar
                    ZStack(alignment: .leading){
                        
                        //MARK: Bar Background - set to clear later
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: width, height: height)
                          //.background(Color(red: 0.9, green: 0.21, blue: 0.21))
                          .cornerRadius(10)
                       
                        
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: value * multiplier, height: height)
                          .background(
                            LinearGradient(colors: [color1, color2], startPoint: .leading, endPoint: .trailing)
                          )
                          .cornerRadius(10)
                          
                    }
                    .frame(width: width, height: height)
                    
                }
                
                //MARK: Percent Label
                
                ZStack {
                    
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 60, height: 50)
                      .background(Color(red: 0.16, green: 0.04, blue: 0.49))
                      .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    
                    Circle()
                        .fill(color2)
                    .frame(width: 42, height: 42)
                    .shadow(color: color2, radius: 0.20869, x: 0, y: 0)
                    .shadow(color: color2, radius: 0.23041, x: 0, y: 0)
                    .shadow(color: color2, radius: 0.46081, x: 0, y: 0)
                    .shadow(color: color2, radius: 0.50425, x: 0, y: 0)
                    .shadow(color: color2, radius: 1.38244, x: 0, y: 0)
                    
                    Circle()
                        .fill(.black)
                    .frame(width: 40, height: 40)
                    
                    
                    Text(String(format: "%.0f", Double(value)))
                    .font(Font.custom("Inter", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(color2)
                    .shadow(color: color2, radius: 0.10434, x: 0, y: 0)
                    .shadow(color: color2, radius: 0.20869, x: 0, y: 0)
                    .shadow(color: color2, radius: 0.23041, x: 0, y: 0)
                    .shadow(color: color2, radius: 0.46081, x: 0, y: 0)
                    .shadow(color: color2, radius: 0.50425, x: 0, y: 0)
                    .shadow(color: color2, radius: 1.38244, x: 0, y: 0)
                

                }
                .frame(width: 60, height: 30)
                
                
                
            }
            .onAppear{
                colorPicker()
            }
            
            

    
            
        }
        .frame(width: 340, height: 99)
        
        
        
    }
        
    
    
    func colorPicker() {
        
        //var diff = 0
        
        if value == 100{
            color1 = GREEN
            color2 = GREEN
        }
        else if value > 74{
            color1 = YELLOW
            color2 = GREEN
        }
//        else if value > 70{
//            diff = 75 - (Int)(value)
//
//            color1 = diff / 4 * ORANGE + (4 - diff) / 4 * YELLOW
//        }
        else if value > 49{
            color1 = ORANGE
            color2 = YELLOW
        }
        else if value > 24{
            color1 = RED
            color2 = ORANGE
        }
        else{
            color1 = Color.black
            color2 = RED
        }
        
    }
}

struct TasteMeter_Previews: PreviewProvider {
    static var previews: some View {
        TasteMeter()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
