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
    var email: String
    @Binding var createLinkSheet: Bool
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
                            Text("Create Your Link")
                            Spacer()
                        }
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.075)).fontWeight(.bold)
                        .frame(width: geometry.size.width-40)
                        
                        TextField("", text: $username, prompt: Text("Username").foregroundColor(.gray)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).autocorrectionDisabled(true).autocapitalization(.none)
                        
                        //                        TextField("", text: $bio, prompt: Text("Bio").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 5).autocorrectionDisabled(true).autocapitalization(.none)
                        
                        VStack {
                            Text("Your new page will be available under ") + Text("kitt.bio/\(username == "" ? "username":username)").fontWeight(.bold)
                        }
                        .padding(.top).padding(.leading, 5)
                        
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                CreateDB().addUser(email: email, username: username) { response in
                                    if response == "User Added" {
                                        print("It works")
                                        profileDetailsShown.toggle()
                                    } else {
                                        print("Unsuccessful user added")
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Text("Create")
                            }
                            .font(Font.system(size: 25))
                            .fontWeight(.semibold)
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
                
            }
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetails()
//    }
//}
