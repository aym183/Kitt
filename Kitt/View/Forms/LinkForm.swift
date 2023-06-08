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
    @Binding var oldIndex: String
    @Binding var linkName: String
    @Binding var linkURL: String
    @State var linkCreated = false
    @State var ifEdit: Bool
    var products_number: Int
    @State var linkDeleted = false
    @Binding var linkEditShown: Bool
    @State var linkIndex: Int?
    @ObservedObject var readData: ReadDB
    @State var isURLValid: Bool = true
    @State var isShowingHint = false
    @State private var isEditingTextField = false
    var areAllFieldsEmpty: Bool {
        return linkName.isEmpty || linkURL.isEmpty
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
                                        DeleteDB().deleteLink(name: readData.products![linkIndex!]["name"]!, url: readData.products![linkIndex!]["url"]!) { response in
                                            if response == "Deleted" {
                                                readData.products?.remove(at: linkIndex!)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    UpdateDB().updateDeleted(products_input: readData.products!)
                                                    linkDeleted.toggle()
                                                }
                                            }
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash").font(.system(size: 20)).background(Circle().fill(.gray).frame(width: 35, height: 35).opacity(0.3)).foregroundColor(.black).fontWeight(.bold).padding(.trailing, 25).padding(.vertical)
                                }

                            } else {
                                Text("New Link").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)
                                
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        isShowingHint.toggle()
                                    }
                                    }) {
                                    Image(systemName: "questionmark")
                                        .background(Circle().fill(.gray).font(.system(size: 12)).frame(width: 25, height: 25).opacity(0.3))
                                        .foregroundColor(.black).fontWeight(.bold).padding(.vertical)
                                        .fontWeight(.semibold).padding(.leading, 10).padding(.top, -3)
                                }
                                Spacer()
                            }
                        }
                        .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                        
                        if isShowingHint {
                            CardView(hint: "Please enter URL in the format 'xyz.com' or starting with 'https://' or 'www.'")
                                .transition(.scale)
                                .padding(.top, -18)
                                .padding(.leading, 110)
//                                .cornerRadius(10, corners: [.topRight, .bottomRight, .bottomLeft])
                        }
                        
                        ZStack {
                            TextField("", text: $linkName, prompt: Text("Link Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().padding(.trailing, 30).frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top, 10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                                .onChange(of: self.linkName, perform: { value in
                                       if value.count > 35 {
                                           self.linkName = String(value.prefix(35))
                                      }
                                  })
                                .onTapGesture {
                                    isEditingTextField = true
                                }
                            
                            if linkName.count > 0 {
                                HStack {
                                    Spacer()
                                    
                                    if linkName.count >= 25 {
                                        Text("\(35 - linkName.count)")
                                            .foregroundColor(.red)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    } else {
                                        Text("\(35 - linkName.count)")
                                            .foregroundColor(.black)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(.trailing, 30).padding(.top, 10)
                        }
                            
                        }
                        
                        
                        TextField("", text: $linkURL, prompt: Text("URL").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                            .onTapGesture {
                                isEditingTextField = true
                            }
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
                                    UpdateDB().updateCreatedLink(old_url: oldURL, new_url: linkURL, old_name: oldName, new_name: linkName, index: String(describing: linkIndex!)) { response in
                                        if response == "Successful" {
                                            linkDeleted.toggle()
//                                            readData.getLinks()
                                        }
                                    }
                                }
//                                linkEditShown.toggle()/
                            } else {
                                DispatchQueue.global(qos: .userInteractive).async {
                                    if products_number != 0 {
                                        UpdateDB().updateLinks(name: linkName, url: linkURL, index: String(describing: products_number))
                                    } else {
                                        CreateDB().addLink(name: linkName, url: linkURL, index: String(describing: products_number))
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
                .onTapGesture {
                    isEditingTextField = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        isEditingTextField = false
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

struct CardView: View {
    let hint: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("TextField"))
            .foregroundColor(.white)
            .frame(width: 180, height: 70)
            .overlay(Text(hint).foregroundColor(.black).font(Font.custom("Avenir-Medium", size: 12)).padding(10))
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

//struct LinkForm_Previews: PreviewProvider {
//    static var previews: some View {
//        LinkForm()
//    }
//}
