//
//  CreateAccountForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct CreateAccountForm: View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @Binding var createAccountSheet: Bool
    @State var showProfileCreation = false
    @Binding var homePageShown: Bool
    @Binding var createLinkSheet: Bool
    var areAllFieldsEmpty: Bool {
        return email.isEmpty || password.isEmpty || confirmPassword.isEmpty
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Create Account").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.08))
                            Spacer()
                            Button(action: { createAccountSheet.toggle() }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        .frame(width: geometry.size.width-40)
                        
                        TextField("", text: $email, prompt: Text("Email").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                        
                        SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                        
                        SecureField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                        
                        Text("By continuing you agree to our Terms of Service.\nKitt services are subject to our Privacy Policy.")
                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).opacity(0.5)
                            .frame(width: geometry.size.width-40, height: 40)
                            .padding(.top, 10).padding(.leading, -15)
                        
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                AuthViewModel().signUp(email: email, password: password) { response in
                                    if response == "Successful" {
                                        showProfileCreation.toggle()
                                    } else {
                                        print("Incorrect email/unmatched passwords")
                                    }
                                }
                            }
                            
                        }) {
                            HStack {
                                Text("Sign Up").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06))
                            }
//                            .font(Font.system(size: 25))
//                            .fontWeight(.semibold)
                            .frame(width: 200, height: 70)
                            .background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white)
                            .cornerRadius(50)
                        }
                        .padding([.vertical])
                        .disabled(areAllFieldsEmpty)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .navigationDestination(isPresented: $showProfileCreation) {
                        CreateLink(homePageShown: $homePageShown, createAccountSheet: $createAccountSheet, email: email, createLinkSheet: $createLinkSheet).navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

//struct CreateAccountForm_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateAccountForm()
//    }
//}