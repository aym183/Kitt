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
                    VStack(alignment: .center) {
                        if profile_image != nil {
                            ZStack {
                                Image(uiImage: profile_image!)
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(width: 145, height: 145)
                            .cornerRadius(100)
                            
//                                .frame(width: 130, height: 130)
//
                        } else {
                            Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        }
                        
//                        Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        VStack(alignment: .center) {
                            Text(name).font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.09)).padding(.top, -8)
                            
                            Text(bio).font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).opacity(0.5).multilineTextAlignment(.center).padding(.horizontal, 50).padding(.bottom)
                            
                        }
                        .frame(width: geometry.size.width-100, height: 100)
                        
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
                                            .frame(height: 64)
                                            .padding(.top, 5)
                                        HStack {
                                            Text(labels[index]).font(Font.custom("Avenir-Medium", size: 18))
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                        }
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 28).padding(.top, 5)
                                    }
                                    .frame(width: geometry.size.width-80)
                                }
                            }
                        
                            HStack {
                                Spacer()
                                ZStack {
                                    Image("LaunchSets").resizable().scaledToFill()
                                }
                                .frame(width: 70, height: 50)
                                .cornerRadius(10).padding(.vertical, 10)
                                
                                Spacer()
                            }
//                            .padding(.top)
//                        }
//                        .padding(.bottom)
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
////
//struct SettingsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsPage()
//    }
//}
