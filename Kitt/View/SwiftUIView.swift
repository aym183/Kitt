//
//  SwiftUIView.swift
//  Kitt
//
//  Created by Ayman Ali on 18/06/2023.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                
                
                LottieView(name: "loading_3.0", speed: 1).frame(width: 100, height: 100)
                
                Text("Getting Kitt Ready! 🥳").font(Font.custom("Avenir-Medium", size: 25)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                
                Spacer()
            }
            .foregroundColor(.black).frame(width: max(0, geometry.size.width))
            
            
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
