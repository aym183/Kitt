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
    var name: String
    var bio: String
    let phoneNumber = "+971506194984"
    @State var profileImageChange = false
    @State var profileNameChange = false
    @State var bioChange = false
    
    // REPLACE WITH APP URL
    let linkURL = URL(string: "https://example.com")!
    
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        if profile_image != nil {
                            Image(uiImage: profile_image!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .cornerRadius(80)
                        } else {
                            Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        }
                        
//                        Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        
                        Text(name).font(.system(size: min(geometry.size.width, geometry.size.height) * 0.09)).fontWeight(.semibold).padding(.top, -8)
                        
                        Text(bio).font(.system(size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.semibold).opacity(0.5).multilineTextAlignment(.center).padding(.horizontal, 10).padding(.bottom)
                        
                        Spacer()
                        
//                        ScrollView(.vertical) {
                            ForEach(0..<5) { index in
                                Button(action: {
                                    if index == 0 {
                                        profileImageChange.toggle()
                                    } else if index == 1 {
                                        profileNameChange.toggle()
                                    } else if index == 2 {
                                        bioChange.toggle()
                                    } else if index == 3 {
                                        if let whatsappURL = URL(string: "https://wa.me/\(phoneNumber)") {
                                            UIApplication.shared.open(whatsappURL)
                                        }
                                    } else {
                                        let activityViewController = UIActivityViewController(activityItems: [linkURL], applicationActivities: nil)
                                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                                    }
                                }) {
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
                    .navigationDestination(isPresented: $profileImageChange) {
                        ChangeProfilePicture()
                    }
                    .navigationDestination(isPresented: $profileNameChange) {
                        ChangeName()
                    }
                    .navigationDestination(isPresented: $bioChange) {
                        ChangeBio()
                    }
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
