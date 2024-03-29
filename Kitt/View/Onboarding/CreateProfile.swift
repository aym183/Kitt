//
//  CreateProfile.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct CreateProfile: View {
    @Binding var signUpShown: Bool
    @Binding var username: String
    @State var fullName = ""
    @State var bio = ""
    @State var profileImageUploadShown = false
    @Binding var homePageShown: Bool
    @Binding var createAccountSheet: Bool
    var email: String
    @Binding var createLinkSheet: Bool
    @State private var isEditingTextField = false
    var areAllFieldsEmpty: Bool {
        return fullName.isEmpty || bio.isEmpty
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Create Profile").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.08))
                            Spacer()
                        }
                        .frame(width: geometry.size.width-40)
                        
                        TextField("", text: $fullName, prompt: Text("Full Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).font(Font.custom("Avenir-Medium", size: 16))
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        ZStack {
                            TextField("", text: $bio, prompt: Text("Bio").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().padding(.trailing, 30).frame(width: max(0, geometry.size.width-40), height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).font(Font.custom("Avenir-Medium", size: 16))
                                .onChange(of: self.bio, perform: { value in
                                       if value.count > 45 {
                                           self.bio = String(value.prefix(45))
                                      }
                                  })
                                .onTapGesture {
                                    isEditingTextField = true
                                }
                            
                            if bio.count > 0 {
                                HStack {
                                    Spacer()
                                    if bio.count >= 35 {
                                        Text("\(45 - bio.count)")
                                            .foregroundColor(.red)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    } else {
                                        Text("\(45 - bio.count)")
                                            .foregroundColor(.black)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(.trailing).padding(.top, 10)
                            }
                        }
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                UpdateDB().updateUserDetails(fullName: fullName.trimmingCharacters(in: .whitespaces), bioText: bio.trimmingCharacters(in: .whitespaces)) { response in
                                    if response == "Successful" {
                                        profileImageUploadShown.toggle()
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Text("Create").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06))
                            }
                            .frame(width: 200, height: 70)
                            .background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white)
                            .cornerRadius(50)
                        }
                        .padding(.top)
                        .disabled(areAllFieldsEmpty)
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .navigationDestination(isPresented: $profileImageUploadShown) {
                        UploadProfileImageForm(signUpShown: $signUpShown, username: $username, homePageShown: $homePageShown, createAccountSheet: $createAccountSheet, createLinkSheet: $createLinkSheet).navigationBarHidden(true)
                    }
                }
                .onTapGesture {
                    isEditingTextField = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        isEditingTextField = false
                    }
                }
        }
    }

}
