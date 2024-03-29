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
import AuthenticationServices
import UIKit

struct LandingPage: View {
    @AppStorage("username") var userName: String = ""
    @State var loggedInUser = false
    @State var isNotificationReceived = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if Auth.auth().currentUser != nil {
                        HomePage(isSignedUp: false, isShownHomePage: true, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false, isShownFromNotification: false)
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
    @State var loginSheet = false
    @State var createLinkSheet = false
    @State var homePageShown = false
    @State var signUpShown = false
    var authVM = AuthViewModel()
    var body: some View {
            GeometryReader { geometry in
                    ZStack {
                        Color(.white).ignoresSafeArea()
                        VStack{
                            
                            HStack {
                                
                                ZStack {
                                    Image("HeaderText")
                                        .resizable()
                                        .scaledToFill()
                                }
                                .frame(width: 100, height: 50)
                                Spacer()
                            }
                            .padding(.top, 50)
                            .padding(.leading, 2)
                            
                            HStack {
                                Text("Welcome to Kitt! 👋")
                                    .font(Font.custom("Avenir-Medium", size: 25)).fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.leading, 10).padding(.bottom, 5)
                            
                            HStack {
                                Text("Kitt is the easiest way to build your business on Instagram.\n\n✅ Start your shop in 5 minutes\n✅ Sell classes, guides, and more!\n✅ Fast AED payouts\n✅ Free to start")
                                    .font(Font.custom("Avenir-Medium", size: 18)).multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.leading, 10).padding(.bottom, 40)
                            
                            Button(action: {
                                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                                let config = GIDConfiguration(clientID: clientID)
                                GIDSignIn.sharedInstance.configuration = config
                                GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                                    guard error == nil else {
                                        return
                                    }
                                    guard let user = result?.user,
                                          let idToken = user.idToken?.tokenString
                                    else {
                                        return
                                    }
                                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                                    
                                    Task {
                                        do {
                                            let result = try await Auth.auth().signIn(with: credential)
                                            ReadDB().getUserDetails(email: (Auth.auth().currentUser?.email!)!) { result in
                                                if result == "Successful" {
                                                    homePageShown.toggle()
                                                } else if result == "User does not exist" || result == "Missing or insufficient permissions." {
                                                    CreateDB().addtoDB() { response in
                                                        if response == "Successful" {
                                                            createLinkSheet.toggle()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        catch {
                                            print("Error authenticating: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }) {
                                HStack(spacing: 3.5) {
                                    Image("Google").resizable().frame(width: 18, height: 18)
                                    Text("Sign in with Google")
                                }
                                .font(.system(size: 18.5))
                                .fontWeight(.medium)
                                .frame(width: 320, height: 50)
                                .background(Color.black).foregroundColor(Color.white)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 50).padding(.bottom, 5)
                            
                            SignInWithAppleButton { request in
                                authVM.handleSignInWithAppleRequest(request)
                            } onCompletion: { result in
                                authVM.handleSignInWithAppleCompletion(result) { response in
                                    if response == "Success" {
                                        ReadDB().getUserDetails(email: (Auth.auth().currentUser?.email!)!) { result in
                                            if result == "Successful" {
                                                homePageShown.toggle()
                                            } else if result == "User does not exist" || result == "Missing or insufficient permissions." {
                                                CreateDB().addtoDB() { response in
                                                    if response == "Successful" {
                                                        createLinkSheet.toggle()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: 320, height: 50)
                            .cornerRadius(10)
                            .padding(.horizontal, 50)
                            .padding(.bottom, 10)
                            
                            Divider().frame(width: 300, height: 1.5).background(Color("Divider")).padding(.bottom, 10)
                            Button(action: { createAccountSheet.toggle() }) {
                                HStack(spacing: 3.5) {
                                    Image("Mail").resizable().frame(width: 18, height: 18)
                                    Text("Sign up with Email")
                                }
                                .font(.system(size: 18.5))
                                .fontWeight(.medium)
                                .frame(width: 320, height: 50)
                                .background(Color.black).foregroundColor(Color.white)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 50)
                            .sheet(isPresented: $createAccountSheet) {
                                CreateAccountForm(signUpShown: $signUpShown, createAccountSheet: $createAccountSheet, homePageShown: $homePageShown, createLinkSheet: $createLinkSheet).presentationDetents([.height(500)])
                            }
                            .sheet(isPresented: $createLinkSheet) {
                                CreateLink(signUpShown: $signUpShown, homePageShown: $homePageShown, createAccountSheet: $createAccountSheet, email: (Auth.auth().currentUser?.email)!, createLinkSheet: $createLinkSheet).presentationDetents([.height(500)])
                            }
                            
                            Button(action: { loginSheet.toggle() }) {
                                HStack(spacing: 3.5) {
                                    Image("Mail").resizable().frame(width: 18, height: 18)
                                    Text("Log in with Email")
                                }
                                .font(.system(size: 18.5))
                                .fontWeight(.medium)
                                .frame(width: 320, height: 50)
                                .background(Color.black).foregroundColor(Color.white)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 50).padding(.bottom).padding(.vertical, 5)
                            .sheet(isPresented: $loginSheet) {
                                LoginForm(loginSheet: $loginSheet, homePageShown: $homePageShown).presentationDetents([.height(400)])
                            }
                        }
                        .frame(width: max(0,geometry.size.width-40), height: max(0, geometry.size.height-20))
                        .foregroundColor(.black)
                        .navigationDestination(isPresented: $homePageShown) {
                            HomePage(isSignedUp: false, isShownHomePage: true, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false, isShownFromNotification: false).navigationBarHidden(true)
                        }
                        .navigationDestination(isPresented: $signUpShown) {
                            HomePage(isSignedUp: true, isShownHomePage: false, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false, isShownFromNotification: false).navigationBarHidden(true)
                        }
                    }
            }
    }
}
