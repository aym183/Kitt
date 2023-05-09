//
//  SwiftUIView.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct UserDetails: View {
    @State var username = ""
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Create Profile")
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.075)).fontWeight(.bold)
                        .frame(width: geometry.size.width-40)
                        
                        TextField("", text: $username, prompt: Text("@username").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 5)
                        
                        Text("Your new page will be available under mishki.com/\(username == "" ? "username":username)")
                            .font(.footnote).fontWeight(.semibold)
                            .padding(.top).padding(.leading, 5)
                            .opacity(0.7)
                        
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetails()
    }
}
