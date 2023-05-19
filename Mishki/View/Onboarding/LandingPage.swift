//
//  LandingPage.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import _AuthenticationServices_SwiftUI
import GoogleSignIn

struct LandingPage: View {
    @AppStorage("username") var userName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if Auth.auth().currentUser != nil {
                        HomePage(isShownHomePage: true, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false)
                    } else {
                        LandingContent()
                    }
                }
            }
        }
    }
}

struct LandingContent: View {
    @State var createAccountSheet = false
    @State var createLinkSheet = false
    @State var homePageShown = false
    var authVM = AuthViewModel()
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack{
                        
                        Text("Kitt").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.2)).fontWeight(.heavy)
                            .foregroundColor(.black)
                            .padding(.top, 120)
                            .padding(.horizontal, 10)
                            .kerning(2.5)
                        
                        
                        Spacer()
                        
                        Button(action: {
                            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                            // Create Google Sign In configuration object.
                            let config = GIDConfiguration(clientID: clientID)
                            GIDSignIn.sharedInstance.configuration = config

                            // Start the sign in flow!
                            GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                              guard error == nil else {
                                // ...
                                  return
                              }

                              guard let user = result?.user,
                                let idToken = user.idToken?.tokenString
                              else {
                                // ...
                                  return
                              }

                              let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                             accessToken: user.accessToken.tokenString)
                                
                            Task {
                                  do {
                                    let result = try await Auth.auth().signIn(with: credential)
                                      createLinkSheet.toggle()
                                  }
                                  catch {
                                    print("Error authenticating: \(error.localizedDescription)")
                                  }
                                }
                              // ...
                            }
                        }) {
                            HStack {
                                Image("Google").foregroundColor(.white)
                                Text("Sign in with Google")
                            }
                            .font(Font.system(size: 20))
                            .fontWeight(.medium)
                            .frame(width: 300, height: 55)
                            .background(Color.black).foregroundColor(Color.white)
                            .cornerRadius(50)
                        }
                        .padding(.horizontal, 50).padding(.bottom, 5)
                        
                        SignInWithAppleButton { request in
                            authVM.handleSignInWithAppleRequest(request)
                        } onCompletion: { result in
                            authVM.handleSignInWithAppleCompletion(result) { response in
                                if response == "Success" {
                                    createLinkSheet.toggle()
                                }
                            }
                        }
                        .frame(width: 300, height: 55)
                        .cornerRadius(50)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 5)
                        
                        Button(action: { createAccountSheet.toggle() }) {
                            HStack {
                                Image(systemName: "envelope.fill").foregroundColor(.white)
                                Text("Sign in with Email")
                            }
                            .font(Font.system(size: 20))
                            .fontWeight(.medium)
                            .frame(width: 300, height: 55)
                            .background(Color.black).foregroundColor(Color.white)
                            .cornerRadius(50)
                        }
                        .padding(.horizontal, 50).padding(.bottom)
                        .sheet(isPresented: $createAccountSheet) {
                            CreateAccountForm(createAccountSheet: $createAccountSheet, homePageShown: $homePageShown, createLinkSheet: $createLinkSheet).presentationDetents([.height(500)])
                        }
                        .sheet(isPresented: $createLinkSheet) {
                            CreateLink(homePageShown: $homePageShown, createAccountSheet: $createAccountSheet, email: (Auth.auth().currentUser?.email)!, createLinkSheet: $createLinkSheet).presentationDetents([.height(500)])
                        }
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $homePageShown) {
                        HomePage(isShownHomePage: true, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
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
