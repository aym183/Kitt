//
//  SwiftUIView.swift
//  Mishki
//
//  Created by Ayman Ali on 19/05/2023.
//

import SwiftUI

struct ChangeName: View {
    @State var name = ""
    @State var profileNameChanged = false
    @AppStorage("full_name") var fullName: String = ""
    @State private var isEditingTextField = false
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack{
                        HStack {
                            Text("Change Name").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical).padding(.leading)
                            
                            Spacer()
                            }    
                        
                        TextField("", text: $name, prompt: Text("Full Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: max(0, geometry.size.width-70), height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).font(Font.custom("Avenir-Medium", size: 16))
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                    UpdateDB().updateFullName(fullName: name) { response in
                                        if response == "Successful" {
                                            profileNameChanged.toggle()
                                        }
                                    }
                                }
                        }) {
                                Text("Update").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: max(0, geometry.size.width-70), height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                        }
                        .padding(.bottom)
                        
                        }
                        .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
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
                        .foregroundColor(.black)
                        .navigationDestination(isPresented: $profileNameChanged) {
                            HomePage(isShownHomePage: false, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                        }
                        .onAppear {
                            name = fullName
                        }
                    }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeName()
//    }
//}
