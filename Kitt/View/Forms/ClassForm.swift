//
//  ClassForm.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct ClassForm: View {

    @State var showImagePicker = false
    @State var classCreated = false
    @State var classDeleted = false
    
    @Binding var oldClassName: String
    @Binding var oldClassDesc: String
    @Binding var oldClassPrice: String
    @Binding var oldClassDuration: String
    @Binding var oldClassSeats: String
    @Binding var oldClassLocation: String
    @Binding var oldImage: UIImage?
    
    @Binding var className: String
    @Binding var classDesc: String
    @Binding var classDuration: String
    @Binding var classPrice: String
    @Binding var classSeats: String
    @Binding var classLocation: String
    @Binding var image: UIImage?
    var classes_number: Int
    @State var ifEdit: Bool
    @State var classIndex: Int?
    @ObservedObject var readData: ReadDB
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        VStack {
                            HStack {
                                if ifEdit {
                                    Text("Edit Class Booking").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        DispatchQueue.global(qos: .userInteractive).async {
                                            DeleteDB().deleteClass(image: readData.classes![classIndex!]["image"]!) { response in
                                                if response == "Deleted" {
                                                    readData.classes?.remove(at: classIndex!)
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        classDeleted.toggle()
                                                    }
                                                }
                                            }
                                        }
                                    }) {
                                        Image(systemName: "trash").background(Circle().fill(.gray).frame(width: 30, height: 30).opacity(0.3)).foregroundColor(.red).fontWeight(.bold).padding(.trailing).padding(.vertical)
                                    }
                                    
                                } else {
                                    Text("New Class Booking").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                            
//                            Button(action: { showImagePicker.toggle() }) {
//                                ZStack {
                                    if let image = self.image {
                                        ZStack {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                                .cornerRadius(10)
                                            
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Button(action: { showImagePicker.toggle() }) {
                                                        Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding(.top).padding(.trailing, 30).fontWeight(.bold)
                                                    }
                                                }
                                                Spacer()
                                            }
                                            
                                        }
                                    } else {
                                        Button(action: { showImagePicker.toggle() }) {
                                            ZStack {
                                                
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color("TextField"))
                                                        .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                                    
                                                    VStack {
                                                        Image(systemName: "plus").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.1)).fontWeight(.semibold)
                                                        Text("Add cover image").padding(.top,5).fontWeight(.semibold)
                                                    }
                                                    .opacity(0.5)
                                            }
                                        }
                                    }
//                                }
                                
//                            }
                            
                            TextField("", text: $className, prompt: Text("Class Name").foregroundColor(.gray)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classDesc, prompt: Text("Class Description").foregroundColor(.gray), axis: .vertical).padding(.top, -55).padding(.horizontal).frame(width: geometry.size.width-70, height: 140).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classDuration, prompt: Text("Class Duration (minutes)").foregroundColor(.gray)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classSeats, prompt: Text("Seats Available").foregroundColor(.gray)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classPrice, prompt: Text("Price (AED)").foregroundColor(.gray)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                            TextField("", text: $classLocation, prompt: Text("Location").foregroundColor(.gray)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                            
                                                        
                            Button(action: {
                                if ifEdit {
                                    DispatchQueue.global(qos: .userInteractive).async {
                                        if let image = self.image {
                                            UpdateDB().updateCreatedClasses(data: ["oldClassName": oldClassName, "oldClassDesc": oldClassDesc, "oldClassPrice": oldClassPrice, "oldClassDuration": oldClassDuration, "oldClassSeats": oldClassSeats, "oldClassLocation": oldClassLocation, "className": className, "classDesc": classDesc, "classDuration": classDuration, "classPrice": classPrice, "classSeats": classSeats, "classLocation": classLocation], old_image: oldImage!, new_image: image) { response in
                                                if response == "Successful" {
                                                    classDeleted.toggle()
                                                }
                                            }
                                        }
                                    }
                                } else {
                                                                
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
                                                                
                                                                
                                }
                            }) {
                                if ifEdit {
                                    Text("Update").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                                } else {
                                    Text("Add").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy).padding(.top)
                                }
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
                        HomePage(isSignedUp: false, isShownHomePage: false, isChangesMade: false, isShownClassCreated: true, isShownProductCreated: false, isShownLinkCreated: false, isShownFromNotification: false).navigationBarHidden(true)
                    }
                    .navigationDestination(isPresented: $classDeleted) {
                        HomePage(isSignedUp: false, isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false, isShownFromNotification: false).navigationBarHidden(true)
                    }
            }
    }
}

//struct ClassForm_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassForm()
//    }
//}
