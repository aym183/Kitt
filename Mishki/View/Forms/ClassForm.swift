//
//  ClassForm.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct ClassForm: View {
    @State var className = ""
    @State var classDesc = ""
    @State var classDuration = ""
    @State var classPrice = ""
    @State var classSeats = ""
    @State var classLocation = ""
    @State var image: UIImage?
    @State var showImagePicker = false
    @State var classCreated = false
    var classes_number: Int
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        VStack {
                            HStack {
                                //                            if ifEdit {
                                //                                Text("Edit Product").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                                //                            } else {
                                Text("New Class Booking").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                                //                            }
                                
                                Spacer()
                            }
                            .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                            
                            Button(action: { showImagePicker.toggle() }) {
                                ZStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                            .cornerRadius(10)
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.gray)
                                            .opacity(0.2)
                                            .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                        
                                        VStack {
                                            Image(systemName: "plus").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.1)).fontWeight(.semibold)
                                            Text("Add cover image").padding(.top,5).fontWeight(.semibold)
                                        }
                                        .opacity(0.5)
                                    }
                                }
                                
                            }
                            
                            TextField("", text: $className, prompt: Text("Class Name").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classDesc, prompt: Text("Class Description").foregroundColor(.black), axis: .vertical).padding(.top, -55).padding(.horizontal).frame(width: geometry.size.width-70, height: 140).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classDuration, prompt: Text("Class Duration (minutes)").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classSeats, prompt: Text("Seats Available").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classPrice, prompt: Text("Price (AED)").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classLocation, prompt: Text("Location").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                                                        
                            Button(action: {
                                //                            if ifEdit {
                                //                                DispatchQueue.global(qos: .userInteractive).async {
                                //                                    if let image = self.image {
                                //                                        UpdateDB().updateCreatedProduct(data: ["oldProductName": oldProductName, "oldProductDesc": oldProductDesc, "oldProductPrice": oldProductPrice, "productName": productName, "productDesc": productDesc, "productPrice": productPrice], old_image: oldImage!, new_image: image) { response in
                                //                                            if response == "Successful" {
                                //                                                productCreated.toggle()
                                //                                            }
                                //                                        }
                                //                                    }
                                //                                }
                                //                            } else {
                                
                                
                                
                                DispatchQueue.global(qos: .userInteractive).async {
                                    if classes_number != 0 {
                                        if let image = self.image {
                                            UpdateDB().updateClasses(image: image, name: className, description: classDesc, price: classPrice, duration: classDuration, seats: classSeats, location: classLocation)
                                        }
                                    } else {
                                        if let image = self.image {
                                            CreateDB().addClasses(image: image, name: className, description: classDesc, price: classPrice, duration: classDuration, seats: classSeats, location: classLocation)
                                        }
                                    }
                                    classCreated.toggle()
                                }
                                
                                
//                                                            }
                            }) {
                                //                            if ifEdit {
                                //                                Text("Update").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                                //                            } else {
                                Text("Add").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy).padding(.top)
                                //                            }
                            }
                            .padding(.bottom)
                            
                        }
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .padding(.top)
                    
                    }
                    .foregroundColor(.black)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                    }
                    .navigationDestination(isPresented: $classCreated) {
                        HomePage(isShownHomePage: false, isChangesMade: false, isShownClassCreated: true, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                    }
            }
    }
}

//struct ClassForm_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassForm()
//    }
//}
