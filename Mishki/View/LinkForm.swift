//
//  LinkForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct LinkForm: View {
    @Binding var oldName: String
    @Binding var oldURL: String
    @Binding var linkName: String
    @Binding var linkURL: String
    @State var linkCreated = false
    @State var ifEdit: Bool
    var links_number: Int
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        HStack {
                            if ifEdit {
                                Text("Edit Link").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                            } else {
                                Text("New Link").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                            }
                            
                            
                            Spacer()
                        }
                        .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                        
                        TextField("", text: $linkName, prompt: Text("Link Name").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 10).disableAutocorrection(true).autocapitalization(.none)
                        
                        TextField("", text: $linkURL, prompt: Text("URL").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                        
                        Spacer()
                        
                        Button(action: {
                            if ifEdit {
                                DispatchQueue.global(qos: .userInteractive).async {
                                    UpdateDB().updateCreatedLink(old_url: oldURL, new_url: linkURL, old_name: oldName, new_name: linkName)
                                }
                            } else {
                                DispatchQueue.global(qos: .userInteractive).async {
                                    if links_number != 0 {
                                        UpdateDB().updateLinks(name: linkName, url: linkURL)
                                    } else {
                                        CreateDB().addLink(name: linkName, url: linkURL)
                                    }
                                }
                                linkCreated.toggle()
                            }
                           
                        }) {
                            if ifEdit {
                                Text("Update").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                            } else {
                                Text("Add").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                            }
                        }
                        .padding(.bottom)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $linkCreated) {
                        HomePage(isShownHomePage: true, isShownProductCreated: false).navigationBarHidden(true)
                    }
                    
                }
                .onAppear {
                    print(oldURL)
                    print(oldName)
                }
        }
        }
}

//struct LinkForm_Previews: PreviewProvider {
//    static var previews: some View {
//        LinkForm()
//    }
//}
