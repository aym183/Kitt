//
//  SocialMediaInput.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct SocialMediaInput: View {
    @State var linkAdded = false
    @State var igUsername = ""
    @State var tiktokUsername = ""
    @State var fbUsername = ""
    @State var ytChannel = ""
    @State var webAddress = ""
    @State var email = ""
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        HStack {
//                            if ifEdit {
//                                Text("Edit Link").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
//                            } else {
                            Text("Add your most important links here").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical).kerning(1.5)

//                            }
                            
                            
                            Spacer()
                        }
                        .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                        
                        Text("These will appear at the top of your profile. If you choose not to add any of the given usernames, just skip them.").foregroundColor(.gray)
                            .font(.footnote).fontWeight(.semibold)
                            .padding(.top).padding(.horizontal, 10).padding(.top, -20)
                        
                        
                        HStack {
                            Image("Instagram").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)
                            
                            TextField("", text: $igUsername, prompt: Text("Instagram username")).padding().frame(width: geometry.size.width-120, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        }
                        .frame(height: 60).background(Color("TextField")).cornerRadius(10).padding(.top)
                        
                        HStack {
                            Image("TikTok").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)
                            
                            TextField("", text: $tiktokUsername, prompt: Text("TikTok Username")).padding().frame(width: geometry.size.width-120, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        }
                        .frame(height: 60).background(Color("TextField")).cornerRadius(10).padding(.top)
                        
                        HStack {
                            Image("Facebook").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)
                            
                            TextField("", text: $fbUsername, prompt: Text("Facebook username")).padding().frame(width: geometry.size.width-120, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        }
                        .frame(height: 60).background(Color("TextField")).cornerRadius(10).padding(.top)
                        
                        HStack {
                            Image("YouTube").frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)
                            
                            TextField("", text: $ytChannel, prompt: Text("YouTube Channel")).padding().frame(width: geometry.size.width-120, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        }
                        .frame(height: 60).background(Color("TextField")).cornerRadius(10).padding(.top)
                        
                        HStack {
                            Image(systemName: "globe").font(Font.system(size: 25)).frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)
                            
                            TextField("", text: $webAddress, prompt: Text("Website Address")).padding().frame(width: geometry.size.width-120, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        }
                        .frame(height: 60).background(Color("TextField")).cornerRadius(10).padding(.top)
                        
                        HStack {
                            Image(systemName: "envelope.circle.fill").font(Font.system(size: 25)).frame(width: 50, height: 60).background(Color("TextField")).cornerRadius(10).padding(.trailing, -10)
                            
                            TextField("", text: $email, prompt: Text("Email Address")).padding().frame(width: geometry.size.width-120, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        }
                        .frame(height: 60).background(Color("TextField")).cornerRadius(10).padding(.top)
                        
                       
                        Spacer()
                        
                        Button(action: {
//                            if ifEdit {
//                                DispatchQueue.global(qos: .userInteractive).async {
//                                    UpdateDB().updateCreatedLink(old_url: oldURL, new_url: linkURL, old_name: oldName, new_name: linkName) { response in
//                                        if response == "Successful" {
//                                            readData.getLinks()
//                                        }
//                                    }
//                                }
//                                linkEditShown.toggle()
//                            } else {
//                                DispatchQueue.global(qos: .userInteractive).async {
//                                    if links_number != 0 {
//                                        UpdateDB().updateLinks(name: linkName, url: linkURL)
//                                    } else {
//                                        CreateDB().addLink(name: linkName, url: linkURL)
//                                    }
//                                }
//                                linkCreated.toggle()
//                            }
                           
                        }) {
                                Text("Update").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                        }
                        .padding(.bottom)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $linkAdded) {
                        HomePage(isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: true).navigationBarHidden(true)
                    }
                    
                }
        }
        }
    }

struct SocialMediaInput_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaInput()
    }
}
