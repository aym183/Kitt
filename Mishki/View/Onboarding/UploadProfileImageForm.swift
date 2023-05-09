//
//  UploadImageForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct UploadProfileImageForm: View {
    @Binding var username: String
    @Binding var homePageShown: Bool
    @Binding var createAccountSheet: Bool
    @State var showImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Pick a profile image")
                            Spacer()
                        }
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.075)).fontWeight(.bold)
                        .frame(width: geometry.size.width-40)
                        
                        Text("Select an image to use as your profile \npicture. It will show up on your page.").padding(.top).padding(.leading, 5)
                        
                        HStack {
                            Button(action: {showImagePicker.toggle()}) {
                                ZStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(50)
                                    } else {
                                        Circle().fill(.gray).opacity(0.2).frame(width: 100, height: 100)
                                        Image(systemName: "plus").fontWeight(.heavy).font(.system(size: 30))
                                    }
                                }
                            }
                            
                            Text("@\(username)").padding(.leading, 30).fontWeight(.bold).font(.system(size: min(geometry.size.width, geometry.size.height) * 0.060)).opacity(0.7)
                            Spacer()
                        }
                        .frame(width: geometry.size.width-60, height: 75)
                        .padding(.vertical, 30).padding(.horizontal, 10)
//
//                        TextField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.black)).padding().frame(width: geometry.size.width-40, height: 75).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 5)

                        
                        HStack {
                            Button(action: {
                                createAccountSheet.toggle()
                                homePageShown.toggle()
                                
                            }) {
                                HStack {
                                    Text("Confirm")
                                }
                                .font(Font.system(size: 25))
                                .fontWeight(.semibold)
                                .frame(width: 200, height: 70)
                                .background(Color.black).foregroundColor(Color.white)
                                .cornerRadius(50)
                            }
                            .padding(.top)
                            
                            Button(action: { homePageShown.toggle() }) {
                                Text("I'll do it later").font(Font.system(size: 20))
                                    .fontWeight(.semibold).padding([.top, .leading])
                            }
                        }
                        
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                    }
                    
                    Spacer()
                }
        }
    }
}

//struct UploadImageForm_Previews: PreviewProvider {
//    static var previews: some View {
//        UploadProfileImageForm(username: "aali183")
//    }
//}
