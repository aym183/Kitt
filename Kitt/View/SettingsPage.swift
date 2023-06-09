//
//  SettingsPage.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import FirebaseFirestore

struct SettingsPage: View {
    var labels = ["Change profile picture", "Change name", "Change bio", "Help", "Refer a friend", "Sign Out"]
    @ObservedObject var readData: ReadDB
    var profile_image: UIImage?
    var name: String
    var bio: String
    let phoneNumber = "+971506194984"
    @State var profileImageChange = false
    @State var profileNameChange = false
    @State var salesPageShown = false
    @State var bioChange = false
    
    let linkURL = URL(string: "https://kitt.bio")!
    
    
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
                            .frame(width: 110, height: 110)
                            .cornerRadius(100)
                            .padding(.top, 10)
                            
//                                .frame(width: 130, height: 130)
//
                        } else {
                            Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        }
                        
//                        Image(systemName: "person.circle").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.25))
                        VStack(alignment: .center) {
                            Text(name).font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.08)).padding(.top, -8).multilineTextAlignment(.center)
//                                .padding(.horizontal, 50)
                            
                            Text(bio).font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).opacity(0.5).multilineTextAlignment(.center).padding(.horizontal, 50).padding(.bottom)
                            
                        }
                        .frame(width: geometry.size.width-50, height: 100)
                        Spacer()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            Button(action: { salesPageShown.toggle() }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("TextField"))
                                        .frame(height: 60)
                                    HStack {
                                        Text("Sales").font(Font.custom("Avenir-Medium", size: 18))
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                    }
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 28)
                                }
                                .frame(width: geometry.size.width-50)
                            }
                            
                            ForEach(0..<6) { index in
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
                                    } else if index == 4 {
                                        let message = "Hey! Check out Kitt to start selling products and services from your Instagram link in bio.\n"
                                        let activityViewController = UIActivityViewController(activityItems: [message, linkURL], applicationActivities: nil)
                                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                                    } else {
                                        print("Sign Out")
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("TextField"))
                                            .frame(height: 60)
//                                            .padding(.top, 5)
                                        HStack {
                                            Text(labels[index]).font(Font.custom("Avenir-Medium", size: 18))
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                        }
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 28)
                                    }
                                    .frame(width: geometry.size.width-50)
                                }
                            }

//                            .padding(.top)
                        }
                        .padding(.bottom, 10).padding(.top, -10)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $salesPageShown) {
                        TotalSales(readData: readData)
                    }
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
    
//    func calculateFontSize(geometry: GeometryProxy, text: String) -> CGFloat {
//        let maxLengthFactor: CGFloat = 0.1
//        let maxWidthFactor: CGFloat = 0.2
//
//        let maxLength = geometry.size.width * maxLengthFactor
//        let maxWidth = geometry.size.width * maxWidthFactor
//
//        let lengthMultiplier = min(1.0, CGFloat(text.count) / maxLength)
//        let widthMultiplier = min(1.0, geometry.size.width / maxWidth)
//
//        let fontSizeMultiplier = min(lengthMultiplier, widthMultiplier)
//
//        return geometry.size.width * fontSizeMultiplier
//    }

}
////
//struct SettingsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsPage()
//    }
//}
