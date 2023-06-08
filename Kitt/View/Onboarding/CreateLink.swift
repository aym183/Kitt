//
//  SwiftUIView.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct CreateLink: View {
    @State var username = ""
    @State var profileDetailsShown = false
    @Binding var homePageShown: Bool
    @Binding var createAccountSheet: Bool
    @State var alertText = ""
    @State var alertShown = false
    var email: String
    @Binding var createLinkSheet: Bool
    @State private var isEditingTextField = false
    var areAllFieldsEmpty: Bool {
        return username.isEmpty
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Create Your Link").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.08))
                            Spacer()
                        }
                        .frame(width: geometry.size.width-40)
                        
                        TextField("", text: $username, prompt: Text("Username").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).autocorrectionDisabled(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        //                        TextField("", text: $bio, prompt: Text("Bio").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 5).autocorrectionDisabled(true).autocapitalization(.none)
                        
                        VStack {
                            Text("Your new page will be available under ").font(Font.custom("Avenir-Medium", size: 18)) + Text("kitt.bio/\(username == "" ? "username":username)").font(Font.custom("Avenir-Medium", size: 18)).fontWeight(.bold)
                        }
                        .padding(.top).padding(.leading, 5)
                        
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                CreateDB().addUser(email: email, username: username) { response in
                                    if response == "User Added" {
                                        profileDetailsShown.toggle()
                                    } else if response == "Username already exists" {
                                        alertText = response!
                                        alertShown.toggle()
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
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .navigationDestination(isPresented: $profileDetailsShown) {
                        CreateProfile(username: $username, homePageShown: $homePageShown, createAccountSheet: $createAccountSheet, email: email, createLinkSheet: $createLinkSheet).navigationBarHidden(true)
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
                .SPAlert(
                    isPresent: $alertShown,
                    title: "Error",
                    message: alertText,
                    duration: 2,
                    dismissOnTap: true,
                    preset: .custom(UIImage(systemName: "exclamationmark")!),
                    haptic: .error
                )
            }
        }
    }
}
