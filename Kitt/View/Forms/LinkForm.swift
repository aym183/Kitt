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
    @State var linkDeleted = false
    @Binding var linkEditShown: Bool
    @State var linkIndex: Int?
    @ObservedObject var readData: ReadDB
    @State var isURLValid: Bool = true
    var areAllFieldsEmpty: Bool {
        return linkName.isEmpty || linkURL.isEmpty || !isURLValid
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        HStack {
                            if ifEdit {
                                Text("Edit Link").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)

                                Spacer()

                                Button(action: {
                                    DispatchQueue.global(qos: .userInteractive).async {
                                        DeleteDB().deleteLink(name: readData.links![linkIndex!]["name"]!, url: readData.links![linkIndex!]["url"]!) { response in
                                            if response == "Deleted" {
                                                readData.links?.remove(at: linkIndex!)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    linkDeleted.toggle()
                                                }
                                            }
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash").background(Circle().fill(.gray).frame(width: 40, height: 40).opacity(0.3)).foregroundColor(.red).fontWeight(.bold).padding(.trailing, 25).padding(.vertical)
                                }

                            } else {
                                Text("New Link").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)
                                
                                Spacer()
                            }
                        }
                        .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                        
                        TextField("", text: $linkName, prompt: Text("Link Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                            .onChange(of: self.linkName, perform: { value in
                                   if value.count > 35 {
                                       self.linkName = String(value.prefix(35))
                                  }
                              })
                        
                        TextField("", text: $linkURL, prompt: Text("URL").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
//                            .onChange(of: linkURL) { newValue in
//                                validateURL()
//                            }
                        
//                        if !isURLValid {
//                            HStack {
//                                Spacer()
//                                Text("Invalid URL").foregroundColor(.red).font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
//                            }
//                            .padding(.trailing, 15)
//                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if ifEdit {
                                DispatchQueue.global(qos: .userInteractive).async {
                                    UpdateDB().updateCreatedLink(old_url: oldURL, new_url: linkURL, old_name: oldName, new_name: linkName) { response in
                                        if response == "Successful" {
                                            readData.getLinks()
                                        }
                                    }
                                }
                                linkDeleted.toggle()
                                linkEditShown.toggle()
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
                                Text("Update").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white).cornerRadius(10)
                            } else {
                                Text("Add").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white).cornerRadius(10)
                            }
                        }
                        .padding(.bottom)
                        .disabled(areAllFieldsEmpty)
                    }
                    .foregroundColor(.black)
                    .padding(.top, -5)
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .navigationDestination(isPresented: $linkCreated) {
                        HomePage(isShownHomePage: false, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: true).navigationBarHidden(true)
                    }
                    .navigationDestination(isPresented: $linkDeleted) {
                        HomePage(isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                    }
                    
                }
        }
        }
//        private func validateURL() {
//            let urlRegex = "^https://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//            let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegex)
//            isURLValid = urlPredicate.evaluate(with: linkURL)
//        }
}

//struct LinkForm_Previews: PreviewProvider {
//    static var previews: some View {
//        LinkForm()
//    }
//}
