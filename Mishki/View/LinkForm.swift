//
//  LinkForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct LinkForm: View {
    @State var linkName = ""
    @State var linkURL = ""
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        HStack {
                            Text("New Link").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                            
                            Spacer()
                        }
                        .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                        
                        TextField("", text: $linkName, prompt: Text("Link Name").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 10)
                        
                        TextField("", text: $linkURL, prompt: Text("URL").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Add").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                        }
                        .padding(.bottom)
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    
                    
                }
            }
        }
        }
}

struct LinkForm_Previews: PreviewProvider {
    static var previews: some View {
        LinkForm()
    }
}
