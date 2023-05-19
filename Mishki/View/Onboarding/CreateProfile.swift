//
//  CreateProfile.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct CreateProfile: View {
    @Binding var username: String
    @State var fullName = ""
    @State var bio = ""
    @State var profileImageUploadShown = false
    @Binding var homePageShown: Bool
    @Binding var createAccountSheet: Bool
    @Binding var email: String
    var areAllFieldsEmpty: Bool {
        return fullName.isEmpty || bio.isEmpty
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Create Profile")
                            Spacer()
                        }
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.075)).fontWeight(.bold)
                        .frame(width: geometry.size.width-40)
                        
                        
                        TextField("", text: $fullName, prompt: Text("Full Name").foregroundColor(.gray)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).autocorrectionDisabled(true).autocapitalization(.none)
                        
                        TextField("", text: $bio, prompt: Text("Bio").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 5).autocorrectionDisabled(true).autocapitalization(.none)
                        
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                UpdateDB().updateUserDetails(fullName: fullName, bioText: bio) { response in
                                    if response == "Successful" {
                                        profileImageUploadShown.toggle()
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
                    .navigationDestination(isPresented: $profileImageUploadShown) {
                        UploadProfileImageForm(username: $username, homePageShown: $homePageShown, createAccountSheet: $createAccountSheet).navigationBarHidden(true)
                    }
                }
            
        }
    }
}

//struct CreateProfile_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateProfile()
//    }
//}
