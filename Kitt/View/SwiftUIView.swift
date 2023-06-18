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
                
                Image("Shop").resizable().frame(width: 90, height: 90)
                
                Text("Congratulations!").font(Font.custom("Avenir-Medium", size: 35)).padding(.top, 10).fontWeight(.bold)
                
                Text("Your store is now ready. Add your first product to start selling.").font(Font.custom("Avenir-Medium", size: 16)).multilineTextAlignment(.center).padding(.top, 0).frame(width: 270)
                
                Spacer()
            }
            .foregroundColor(.black).frame(width: max(0, geometry.size.width))
            
            LottieView().frame(width: max(0, geometry.size.width))
            
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
