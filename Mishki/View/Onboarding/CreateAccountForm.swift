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
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Create Account")
                            Spacer()
                            Button(action: { createAccountSheet.toggle() }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.075)).fontWeight(.bold)
                        .frame(width: geometry.size.width-40)
                        
                        TextField("", text: $email, prompt: Text("Email").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 5)
                        
                        TextField("", text: $password, prompt: Text("Password").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 5)
                        
                        TextField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 5)
                        
                        Text("By continuing you agree to our Terms of Service.\nOpenrack services are subject to our Privacy Policy.")
                            .font(.footnote).fontWeight(.semibold)
                            .padding(.top).padding(.leading, 5)
                            .opacity(0.7)
                        
                        
                        Button(action: {}) {
                            HStack {
                                Text("Sign Up")
                            }
                            .font(Font.system(size: 25))
                            .fontWeight(.semibold)
                        }
                        .frame(width: 200, height: 60)
                        .background(Color.black).foregroundColor(Color.white)
                        .cornerRadius(50)
                        .padding(.top)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                }
            }
        }
    }
}

//struct CreateAccountForm_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateAccountForm(, createAccountSheet: <#Binding<Bool>#>)
//    }
//}