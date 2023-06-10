//
//  CreateAccountForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import SPAlert

struct CreateAccountForm: View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var alertText = ""
    @State var alertShown = false
    @Binding var createAccountSheet: Bool
    @State var showProfileCreation = false
    @State var isEmailValid: Bool = true
    @State var errorText: Bool = false
    @Binding var homePageShown: Bool
    @Binding var createLinkSheet: Bool
    @State private var isEditingTextField = false
    var areAllFieldsEmpty: Bool {
        return (email.isEmpty || password.isEmpty || confirmPassword.isEmpty ) || (isEmailValid && password != confirmPassword)
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
                            .onChange(of: email) { newValue in
                                withAnimation(.easeOut(duration: 0.2)) {
                                    validateEmail()
                                }
                            }
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        if !isEmailValid {
                            HStack {
                                Spacer()
                                Text("Invalid Email").foregroundColor(.red).font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
                            .padding(.trailing, 5)
                        }
                        
                        SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        SecureField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        if password != confirmPassword {
                            HStack {
                                Spacer()
                                Text("Passwords do not match").foregroundColor(.red).font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
                            .padding(.trailing, 5)
                        }
                        
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
                                        alertText = response!
                                        alertShown.toggle()
//                                        print("Incorrect email/unmatched passwords")
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
                        .padding(.bottom)
                        .disabled(areAllFieldsEmpty)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .navigationDestination(isPresented: $showProfileCreation) {
                        CreateLink(homePageShown: $homePageShown, createAccountSheet: $createAccountSheet, email: email, createLinkSheet: $createLinkSheet).navigationBarHidden(true)
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
    
    private func validateEmail() {
            let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            isEmailValid = emailPredicate.evaluate(with: email)
    }
}

//struct CreateAccountForm_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateAccountForm()
//    }
//}
