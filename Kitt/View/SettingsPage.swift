//
//  SettingsPage.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import FirebaseFirestore

struct SettingsPage: View {
    var labels = ["Sales", "Payout details", "Edit profile", "Help", "Refer a friend", "Sign out"]
    @ObservedObject var readData: ReadDB
    var profile_image: UIImage?
    var name: String
    var bio: String
    let phoneNumber = "+971304929456"
    @State var profileImageChange = false
    @State var profileNameChange = false
    @State var salesPageShown = false
    @State var payoutDetailsShown = false
    @State var bioChange = false
    @State var signedOut = false
    @State var showingSignOutConfirmation = false
    let linkURL = URL(string: "https://kitt.bio")!
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .center) {
                        HStack {
                            if profile_image != nil {
                                ZStack {
                                    Image(uiImage: profile_image!)
                                        .resizable()
                                        .scaledToFill()
                                }
                                .frame(width: 75, height: 75)
                                .cornerRadius(100)
                            } else {
                                ZStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .scaledToFill()
                                }
                                .frame(width: 75, height: 75)
                            }
                            
                            Text(name).font(Font.custom("Avenir-Black", size: 20)).multilineTextAlignment(.leading).padding(.leading, 10)
                            Spacer()
                            
                        }
                        .padding(.horizontal, 5).padding(.bottom, 20).padding(.top, -40)

                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(0..<6) { index in
                                Button(action: {
                                    if index == 0 {
                                        salesPageShown.toggle()
                                    } else if index == 1 {
                                        payoutDetailsShown.toggle()
                                    } else if index == 2 {
                                        profileImageChange.toggle()
                                        
                                    } else if index == 3 {
                                        if let whatsappURL = URL(string: "https://wa.me/\(phoneNumber)") {
                                            UIApplication.shared.open(whatsappURL)
                                        }
                                    }
                                    else if index == 4 {
                                        let message = "Hey! Check out Kitt to start selling products and services from your Instagram link in bio.\n"
                                        let activityViewController = UIActivityViewController(activityItems: [message, linkURL], applicationActivities: nil)
                                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                                    }
                                    else {
                                        showingSignOutConfirmation = true
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("TextField"))
                                            .frame(height: 60)
                                        HStack {
                                            Text(labels[index]).font(Font.custom("Avenir-Medium", size: 18))
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                        }
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 28)
                                    }
                                    .frame(width: max(0, geometry.size.width-50))
                                }
                            }
                        }
                        .frame(height: 500)
                        .padding(.bottom, 10)
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $salesPageShown) {
                        TotalSales(readData: readData)
                    }
                    .navigationDestination(isPresented: $profileImageChange) {
                        EditProfile()
                    }
                    .navigationDestination(isPresented: $payoutDetailsShown) {
                        PayoutDetails()
                    }
                    .navigationDestination(isPresented: $signedOut) {
                        LandingContent().navigationBarBackButtonHidden(true)
                    }
                    .alert(isPresented: $showingSignOutConfirmation) {
                        Alert(
                            title: Text("Are you sure you want to sign out?"),
                            primaryButton: .default(Text("Yes")) {
                                AuthViewModel().signOut() { response in
                                    if response == "Successful" {
                                        signedOut.toggle()
                                    }
                                }
                                showingSignOutConfirmation = false
                            },
                            secondaryButton: .cancel() {
                                showingSignOutConfirmation = false
                            }
                        )
                    }
                }
        }
    }
}
