//
//  LoginForm.swift
//  Kitt
//
//  Created by Ayman Ali on 08/06/2023.
//

import SwiftUI

struct LoginForm: View {
    @Binding var loginSheet: Bool
    @Binding var homePageShown: Bool
    @State var email = ""
    @State var password = ""
    @State var isEmailValid: Bool = true
    @State var alertText = ""
    @State var alertShown = false
    @State private var isEditingTextField = false
    var areAllFieldsEmpty: Bool {
        return email.isEmpty || password.isEmpty || !isEmailValid
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Login").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.08))
                            Spacer()
                            Button(action: { loginSheet.toggle() }) {
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
                        
                        Text("By continuing you agree to our Terms of Service.\nKitt services are subject to our Privacy Policy.")
                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).opacity(0.5)
                            .frame(width: geometry.size.width-40, height: 40)
                            .padding(.top, 10).padding(.leading, -15)
                        
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                AuthViewModel().signIn(email: email, password: password) { response in
                                    if response == "Successful" {
                                        loginSheet.toggle()
                                        homePageShown.toggle()
                                    } else {
                                        alertText = response!
                                        alertShown.toggle()
//                                        print("Incorrect email/unmatched passwords")
                                    }
                                }
                            }
                            
                        }) {
                            HStack {
                                Text("Login").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06))
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
                    duration: 1,
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

//struct LoginForm_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginForm()
//    }
//}
