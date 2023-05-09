//
//  LandingPage.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import FirebaseAuth

struct LandingPage: View {
    @AppStorage("username") var userName: String = ""
    
    var body: some View {
            ZStack {
                VStack {
//                    if Auth.auth().currentUser != nil {
//                       HomePage()
//                    } else {
                        LandingContent()
//                    }
                }
            }
    }
}

struct LandingContent: View {
    @State var createAccountSheet = false
    @State var homePageShown = false
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack{
                        
                        Text("Mishki").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.2)).fontWeight(.heavy)
                            .foregroundColor(.black)
                            .padding(.top, 120)
                            .padding(.horizontal, 10)
                            .kerning(2.5)
                        
                        
                        Spacer()
                        
                        Button(action: { createAccountSheet.toggle() }) {
                            HStack {
                                Text("Get Started")
                                Image(systemName: "arrow.forward")
                            }
                            .font(Font.system(size: 25))
                            .fontWeight(.semibold)
                            .frame(width: 300, height: 70)
                            .background(Color.black).foregroundColor(Color.white)
                            .cornerRadius(50)
                        }
                        .padding(.horizontal, 50).padding(.bottom)
                        .sheet(isPresented: $createAccountSheet) {
                            CreateAccountForm(createAccountSheet: $createAccountSheet, homePageShown: $homePageShown).presentationDetents([.height(500)])
                        }
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $homePageShown) {
                        HomePage().navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
