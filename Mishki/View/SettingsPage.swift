//
//  SettingsPage.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct SettingsPage: View {
    var labels = ["Change profile picture", "Change name", "Change bio", "Help" , "Refer a friend"]
    @ObservedObject var readData: ReadDB
    var profile_image: UIImage?
    var username: String
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        if profile_image != nil {
                            Image(uiImage: profile_image!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                        } else {
                            Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        }
                        
//                        Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        
                        Text(username).font(.system(size: min(geometry.size.width, geometry.size.height) * 0.1)).fontWeight(.semibold).padding(.top, -10)
                        
                        Text("fitness trainer and wellness coach,\n living in Dubai").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.semibold).opacity(0.5).multilineTextAlignment(.center)
                        
                        Spacer()
                        
//                        ScrollView(.vertical) {
                            ForEach(0..<5) { index in
                                Button(action: {}) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.gray)
                                            .opacity(0.2)
                                            .frame(height: 60)
                                            .padding(.top,10)
                                        HStack {
                                            Text(labels[index])
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                        }
                                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .fontWeight(.semibold)
                                        .padding(.horizontal).padding(.top, 5)
                                    }
                                    .frame(width: geometry.size.width-70)
                                }
                            }
                            HStack {
                                Spacer()
                                Image("LaunchSets").resizable().frame(width: 60, height: 50).cornerRadius(10).padding(.top, 10).padding(.leading, -8)
                                Spacer()
                            }
                            .padding(.top)
//                        }
                        .padding(.bottom)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                }
        }
    }
}
//
//struct SettingsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsPage()
//    }
//}
