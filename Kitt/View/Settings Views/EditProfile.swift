//
//  changeProfilePicture.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct EditProfile: View {
    @AppStorage("bio") var bioText: String = ""
    @AppStorage("full_name") var fullName: String = ""
    @State var image: UIImage?
    @State var name = ""
    @State var bio = ""
    @State var showImagePicker = false
    @State var profileImageChanged = false
    @State private var isEditingTextField = false
    var areAllFieldsEmpty: Bool {
       image == nil && name == fullName && bio == bioText
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack{
                        HStack {
                            Text("Edit Profile").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical).padding(.leading)
                            
                            Spacer()
                            }
                            
                        
                        Button(action: { showImagePicker.toggle() }) {
                            ZStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: max(0, geometry.size.width-70), height: max(0, geometry.size.height-450))
                                        .cornerRadius(10)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("TextField"))
                                        .frame(width: max(0, geometry.size.width-70), height: max(0, geometry.size.height-450))
                                    VStack {
                                        Image(systemName: "plus").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.1)).fontWeight(.semibold)
                                        Text("Change profile image").padding(.top,5).fontWeight(.semibold)
                                    }
                                    .opacity(0.5)
                                }
                            }
                            
                        }
                        
                        TextField("", text: $name, prompt: Text("Full Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: max(0, geometry.size.width-70), height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).font(Font.custom("Avenir-Medium", size: 16))
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        
                        ZStack {
                            TextField("", text: $bio, prompt: Text("Bio").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().padding(.trailing, 30).frame(width: max(0, geometry.size.width-70), height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).font(Font.custom("Avenir-Medium", size: 16))
                                .onChange(of: self.bio, perform: { value in
                                       if value.count > 50 {
                                           self.bio = String(value.prefix(50))
                                      }
                                  })
                                .onTapGesture {
                                    isEditingTextField = true
                                }
                            
                            if bio.count > 0 {
                                HStack {
                                    Spacer()
                                    
                                    if bio.count >= 40 {
                                        Text("\(50 - bio.count)")
                                            .foregroundColor(.red)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    } else {
                                        Text("\(50 - bio.count)")
                                            .foregroundColor(.black)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(.trailing, 30)
                                .frame(height: 60)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                
                                    if let image = self.image {
                                        CreateDB().uploadProfileImage(image: image) { response in
                                            if response == "Cached" {
//                                                profileImageChanged.toggle()
                                                print("Image Changed")
                                            }
                                        }
                                    }
                                    
                                    if name != fullName ||  bio != bioText {
                                        UpdateDB().updateFullName(fullName: name) { response in
                                            if response == "Successful" {
                                                print("Name updated")
                                            }
                                        }
                                        
                                        UpdateDB().updateBio(bioText: bio) { response in
                                            if response == "Successful" {
                                                print("Bio updated")
                                            }
                                        }
                                        
                                    }
                                
                                    profileImageChanged.toggle()
                                }
                        }) {
                                Text("Update Details").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: max(0,geometry.size.width-70), height: 60).background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white).cornerRadius(10)
                        }
                        .padding(.bottom)
                        .disabled(areAllFieldsEmpty)
                        
                        }
                        .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
                        }
                        .onAppear {
                            bio = bioText
                            name = fullName
                        }
                        .foregroundColor(.black)
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: $image)
                        }
                        .navigationDestination(isPresented: $profileImageChanged) {
                            HomePage(isSignedUp: false, isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                        }
                    }
                    
            }
    }

struct changeProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
