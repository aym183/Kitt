//
//  SocialMediaInput.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct SocialMediaInput: View {
    @State var linkAdded = false
//    @State var igUsername = ""
//    @State var tiktokUsername = ""
//    @State var fbUsername = ""
//    @State var ytChannel = ""
//    @State var webAddress = ""
    @AppStorage("instagram") var igUsername: String = ""
    @AppStorage("tiktok") var tiktokUsername: String = ""
    @AppStorage("facebook") var fbUsername: String = ""
    @AppStorage("youtube") var ytChannel: String = ""
    @AppStorage("website") var webAddress: String = ""
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
//                    ScrollView(showsIndicators: false) {
                    VStack {
                        Text("Add your most important\nlinks here").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical).padding(.leading, -20)
                                
//                            .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                            
                            Text("These will appear at the top of your profile. If you choose not to add any of the given usernames, just skip them.").font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).opacity(0.5).padding(.leading, 15).padding(.trailing, 10).padding(.top, -10)
                            

                            HStack {
                                Image("Instagram").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)

                                TextField("", text: $igUsername, prompt: Text("Instagram username").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-120, height: 65).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16)).padding(.leading, -10)
                            }
                            .frame(width: geometry.size.width-70, height: 60).background(Color("TextField")).cornerRadius(10).padding(.top, 10)
                            HStack {
                                Image("TikTok").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)

                                TextField("", text: $tiktokUsername, prompt: Text("Tiktok username").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-120, height: 65).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16)).padding(.leading, -10)
                            }
                            .frame(width: geometry.size.width-70, height: 60).background(Color("TextField")).cornerRadius(10).padding(.top, 10)

                            HStack {
                                Image("Facebook").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)

                                TextField("", text: $fbUsername, prompt: Text("Facebook username").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-120, height: 65).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16)).padding(.leading, -10)
                            }
                            .frame(width: geometry.size.width-70, height: 60).background(Color("TextField")).cornerRadius(10).padding(.top, 10)

                            HStack {
                                Image("YouTube").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)

                                TextField("", text: $ytChannel, prompt: Text("YouTube channel").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-120, height: 65).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16)).padding(.leading, -10)
                            }
                            .frame(width: geometry.size.width-70, height: 60).background(Color("TextField")).cornerRadius(10).padding(.top, 10)

                            HStack {
                                Image("Globe").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)

                                TextField("", text: $webAddress, prompt: Text("Website address").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-120, height: 65).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16)).padding(.leading, -10)

                            }
                            .frame(width: geometry.size.width-70, height: 60).background(Color("TextField")).cornerRadius(10).padding(.top, 10)

//                            HStack {
//                                Image("Mail").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)
//
//                                TextField("", text: $email, prompt: Text("Email Address").foregroundColor(.gray)).padding().frame(width: geometry.size.width-120, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
//                            }
//                            .frame(height: 60).background(Color("TextField")).cornerRadius(10).padding(.top, 10)

//
                            Spacer()
                            
                            Button(action: {
                              DispatchQueue.global(qos: .userInteractive).async {
                                  UpdateDB().updateSocials(instagram: igUsername, tiktok: tiktokUsername, facebook: fbUsername, youtube: ytChannel, website: webAddress)
                                  linkAdded.toggle()
                              }
                                
                            }) {
                                Text("Update").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10)
                            }
                            .padding(.bottom)
                        }
                        .frame(width: geometry.size.width-40, height: geometry.size.height-15)
                        .foregroundColor(.black)
                        .navigationDestination(isPresented: $linkAdded) {
                            HomePage(isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                        }
//                    }
                    
                }
        }
        }
    }


struct SocialMediaInput_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaInput()
    }
}