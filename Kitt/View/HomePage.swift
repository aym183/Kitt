//
//  ContentView.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import UIKit
import SPAlert

struct HomePage: View {
    @State var formShown = false
    @State var settingsShown = false
    @State var salesShown = false
    @State var isSignedUp: Bool
    @State var isShownHomePage: Bool
    @State var isChangesMade: Bool
    @State var isShownClassCreated: Bool
    @State var isShownProductCreated: Bool
    @State var isShownLinkCreated: Bool
    @State var isShownFromNotification: Bool
    @AppStorage("username") var userName: String = ""
    @AppStorage("full_name") var fullName: String = ""
    @AppStorage("bio") var bioText: String = ""
    @StateObject var readData = ReadDB()
    @State var oldProductIndex = ""
    @State var oldLinkIndex = ""
    @State var oldProductName = ""
    @State var oldProductDesc = ""
    @State var oldProductPrice = ""
    @State var oldImage: UIImage?
    @State var oldFileName = ""
    @State var oldFile = ""
    @State var file = ""
    @State var fileName = ""
    @State var productName = ""
    @State var productDesc = ""
    @State var productPrice = ""
    @State var image: UIImage?
    @State var temp_products: [[String: String]] = []
//    @State var oldClassName = ""
//    @State var oldClassDesc = ""
//    @State var oldClassPrice = ""
//    @State var oldClassSeats = ""
//    @State var oldClassLocation = ""
//    @State var oldClassDuration = ""
//    @State var oldClassImage: UIImage?
//    @State var className = ""
//    @State var classDesc = ""
//    @State var classDuration = ""
//    @State var classPrice = ""
//    @State var classSeats = ""
//    @State var classLocation = ""
//    @State var classImage: UIImage?
    @State var oldName = ""
    @State var oldURL = ""
    @State var linkName = ""
    @State var linkURL = ""
    @State var linksNumber = 0
    @State var productsNumber = 0
    @State var classesNumber = 0
    @State var productIndex = 0
    @State var linkIndex = 0
    @State var classIndex = 0
    @State var profile_image: UIImage?
    @State var productEditShown = false
    @State var classEditShown = false
    @State var linkEditShown = false
    @State var socialsEditShown = false
    @State var showingAlert = false
    @ObservedObject var appState = AppState.shared
    @EnvironmentObject private var appDelegate: AppDelegate
    @State var isUpdating = false
    
    var body: some View {
        var noOfLinks = readData.links?.count ?? 0
        var noOfProducts = readData.products?.count ?? 0
        var noOfClasses = readData.classes?.count ?? 0
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    
                    if isSignedUp {
                            VStack(alignment: .center) {
                                Spacer()
                                Image("Shop").resizable().frame(width: 90, height: 90)
                                Text("Congratulations!").font(Font.custom("Avenir-Medium", size: 35)).padding(.top, 10).fontWeight(.bold)
                                Text("Your store is now ready. Add your first product to start selling.").font(Font.custom("Avenir-Medium", size: 16)).multilineTextAlignment(.center).padding(.top, 0).frame(width: 270)
                                Spacer()
                            }
                            .foregroundColor(.black)
                            .frame(width: max(0, geometry.size.width))
                            LottieView(name: "confetti", speed: 0.5).frame(width: max(0, geometry.size.width))
                    }
                    
                    if isShownHomePage {
                        VStack(alignment: .center) {
                            Spacer()
                            LottieView(name: "loading_3.0", speed: 1).frame(width: 100, height: 100)
                            Text("Getting Kitt Ready! 🥳").font(Font.custom("Avenir-Medium", size: 25)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                            Spacer()
                        }
                        .foregroundColor(.black).frame(width: max(0, geometry.size.width))
                    }
                    
                    if isChangesMade {
                        VStack(alignment: .center) {
                            Spacer()
                            LottieView(name: "loading_3.0", speed: 1).frame(width: 100, height: 100)
                            Text("Implementing changes...").font(Font.custom("Avenir-Medium", size: 25)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                            Spacer()
                        }
                        .foregroundColor(.black).frame(width: max(0, geometry.size.width))
                    }
                    
                    if isShownLinkCreated {
                        VStack(alignment: .center) {
                            Spacer()
                            LottieView(name: "loading_3.0", speed: 1).frame(width: 100, height: 100)
                            Text("Creating your link!").font(Font.custom("Avenir-Medium", size: 25)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                            Spacer()
                        }
                        .foregroundColor(.black).frame(width: max(0, geometry.size.width))
                    }
                    
                    if isShownClassCreated {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            Text("Creating your class!").font(Font.custom("Avenir-Medium", size: 20)).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isShownProductCreated {
                        VStack(alignment: .center) {
                            Spacer()
                            LottieView(name: "loading_3.0", speed: 1).frame(width: 100, height: 100)
                            Text("Creating your product!").font(Font.custom("Avenir-Medium", size: 25)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                            Spacer()
                        }
                        .foregroundColor(.black).frame(width: max(0, geometry.size.width))
                    }
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("kitt.bio/\(userName)").font(Font.custom("Avenir-Black", size: 20))
                                HStack(spacing: 25) {
                                    Button(action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = "kitt.bio/\(userName)"
                                        showingAlert.toggle()
                                    }) {
                                        Image(systemName: "doc").background(
                                            Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                        )
                                    }
                                    .SPAlert(
                                        isPresent: $showingAlert,
                                        message: "Link copied to clipboard",
                                        duration: 1,
                                        haptic: .success
                                    )
                                    
                                    Button(action: {
                                        
                                        guard let url = URL(string: "https://kitt.bio/\(userName)") else {
                                            return
                                        }
                                        guard UIApplication.shared.canOpenURL(url) else {
                                            return
                                        }
                                        UIApplication.shared.open(url)
                                    }) {
                                        Image(systemName: "arrow.up.forward").background(
                                            Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                        )
                                    }
                                }
                                .font(Font.system(size: 13))
                                .padding(.leading, 10).padding(.top, 0.5)
                                .fontWeight(.bold)
                                
                            }
                            Spacer()
                            
                            Button(action: { settingsShown.toggle() }) {
                                
                                if profile_image != nil {
                                    ZStack {
                                        Image(uiImage: profile_image!)
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(100)
                                } else {
                                    Image(systemName: "person.circle").font(Font.system(size: 80))
                                }
                            }
                            .padding(.top, 22)
                        }
                        .padding(.horizontal, 5)
                        
                        HStack {
                            Button(action: {
                                productsNumber = noOfProducts
                                classesNumber = noOfClasses
                                formShown.toggle()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus").fontWeight(.black)
                                    Text("Add").font(Font.custom("Avenir-Black", size: 20))
                                }
                                .frame(width: 85, height: 35).padding(4).background(.black).foregroundColor(.white).cornerRadius(10)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 5).padding(.top, -5)
                        
                        Spacer()
                        
                        if isUpdating {
                            VStack(alignment: .center) {
                                Spacer()
                                LottieView(name: "loading_3.0", speed: 1).frame(width: 75, height: 75)
                                Text("Loading...").font(Font.custom("Avenir-Medium", size: 20)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                                Spacer()
                            }
                            .foregroundColor(.black).frame(width: max(0, geometry.size.width))
                        } else {
                                List {
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10).fill(Color("TextField")).frame(width: max(0, geometry.size.width-50), height: 70)
                                        HStack {
                                            Text("😎").padding(.leading, 20)
                                            Text("Your Social Links").foregroundColor(.black).font(Font.custom("Avenir-Medium", size: 15))
                                            Spacer()
                                            Button(action: { socialsEditShown.toggle() }) {
                                                Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).fontWeight(.bold)
                                                    .padding(.trailing, 5)
                                            }
                                        }
                                        .padding(.trailing)
                                    }
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .background(.white)
                                    .listRowBackground(Color.white)
                                    .listRowSeparator(.hidden)
                                    
                                    ForEach(0..<noOfProducts, id: \.self) { index in
                                        
                                        if readData.products![index]["description"] != nil {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10).fill(Color("TextField")).frame(width: max(0, geometry.size.width-50), height: 110)
                                                HStack {
                                                    ZStack {
                                                        Image(uiImage: readData.loadProductImage(key: readData.products![index]["image"]!)).resizable().scaledToFill()
                                                    }
                                                    .frame(width: 110, height: 110)
                                                    .cornerRadius(10)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text("\(readData.products![index]["name"]!)").font(Font.custom("Avenir-Black", size: 15)).padding(.top, 5)
                                                        Spacer()
                                                        
                                                        HStack {
                                                            Text("\(readData.products![index]["price"]!) AED").font(Font.custom("Avenir-Medium", size: 15))
                                                            Spacer()
                                                            Button(action: {
                                                                    productIndex = index
                                                                    productName = readData.products![index]["name"]!
                                                                    productDesc = readData.products![index]["description"]!
                                                                    productPrice = "\(readData.products![index]["price"]!)"
                                                                    fileName = readData.products![index]["file_name"]!
                                                                    file = readData.products![index]["file"]!
                                                                    oldFile = readData.products![index]["file"]!
                                                                    oldFileName = readData.products![index]["file_name"]!
                                                                    oldProductName = readData.products![index]["name"]!
                                                                    oldProductDesc = readData.products![index]["description"]!
                                                                    oldProductPrice = "\(readData.products![index]["price"]!)"
                                                                    oldImage = readData.loadProductImage(key: readData.products![index]["image"]!)
                                                                    image = readData.loadProductImage(key: readData.products![index]["image"]!)
                                                                    productEditShown.toggle()
                                                            }) {
                                                                Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding(.trailing, 5).fontWeight(.bold)
                                                            }
                                                        }
                                                        .padding(.trailing, 10)
                                                        .padding(.bottom, 10)
                                                    }
                                                    .frame(height: 110)
                                                    .padding(.horizontal, 5)
                                                }
                                            }
                                            .padding(.bottom, 5)
                                            .padding(.horizontal)
                                            .multilineTextAlignment(.leading)
                                            .id(readData.products![index]["index"])
                                            .background(.white)
                                            .listRowBackground(Color.white)
                                            
                                        } else {
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10).fill(Color("TextField")).frame(width: max(0, geometry.size.width-50), height: 70)
                                                HStack {
                                                    Text(readData.products![index]["name"]!).foregroundColor(.black).font(Font.custom("Avenir-Medium", size: 15)).padding(.leading, 20)
                                                    Spacer()
                                                    Button(action: {
                                                            linkIndex = index
                                                            linkName = readData.products![index]["name"]!
                                                            linkURL = readData.products![index]["url"]!
                                                            oldName = readData.products![index]["name"]!
                                                            oldURL = readData.products![index]["url"]!
                                                            linkEditShown.toggle()
                                                        
                                                    }) {
                                                        Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).fontWeight(.bold)
                                                    }
                                                    .padding(.trailing, 5)
                                                    
                                                }
                                                .padding(.trailing)
                                            }
                                            .padding(.horizontal)
                                            .padding(.bottom, 5)
                                            .multilineTextAlignment(.leading)
                                            .id(readData.products![index]["index"])
                                            .background(.white)
                                            .listRowBackground(Color.white)
                                            
                                        }
                                    }
                                    .onMove(perform: move)
                                    .listRowSeparator(.hidden)
                                    .padding(.vertical, -5)
                                    
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .padding(.vertical)
                        }
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
                    .navigationDestination(isPresented: $socialsEditShown) {
                        SocialMediaInput()
                    }
                    .navigationDestination(isPresented: $formShown) {
                        FormSelection(links_number: linksNumber, products_number: productsNumber, classes_number: classesNumber, readData: readData)
                    }
                    .navigationDestination(isPresented: $settingsShown) {
                        SettingsPage(readData: readData, profile_image: profile_image, name: fullName, bio: bioText)
                    }
                    .navigationDestination(isPresented: $salesShown) {
                        TotalSales(readData: readData)
                    }
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .onAppear {
                        readData.sales = []
                        DispatchQueue.global(qos: .userInteractive).async {
                            readData.getProducts_rt()
                            readData.getSales_rt()
                            readData.loadProfileImage() { response in
                                if response != nil {
                                    profile_image = response!
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isShownHomePage = false
                                    isShownLinkCreated = false
                                    isChangesMade = false
                                    if appState.pageToNavigationTo != nil && !isShownHomePage {
                                        salesShown = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            appState.pageToNavigationTo = nil
                                        }
                                    }
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isShownProductCreated = false
                                    isShownClassCreated = false
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                withAnimation(.easeOut(duration: 1.5)) {
                                    isSignedUp = false
                                    if isSignedUp == false {
                                        appDelegate.registerPushNotifications()
                                    }
                                }
                            }
                        }
                    }
                    .opacity(isShownHomePage ? 0 : 1)
                    .opacity(isShownProductCreated ? 0 : 1)
                    .opacity(isShownLinkCreated ? 0 : 1)
                    .opacity(isShownClassCreated ? 0 : 1)
                    .opacity(isChangesMade ? 0 : 1)
                    .opacity(isSignedUp ? 0 : 1)
                }
                .navigationDestination(isPresented: $productEditShown) {
                    ProductForm(oldIndex: $oldProductIndex, oldProductName: $oldProductName, oldProductDesc: $oldProductDesc, oldProductPrice: $oldProductPrice, oldImage: $oldImage, oldFile: $oldFile, oldFileName: $oldFileName, productName: $productName, productDesc: $productDesc, productPrice: $productPrice, image: $image, file: $file, fileName: $fileName, products_number: productsNumber, ifEdit: true, productIndex: productIndex, readData: readData)
                }
                .navigationDestination(isPresented: $linkEditShown) {
                    LinkForm(oldName: $oldName, oldURL: $oldURL, oldIndex: $oldLinkIndex, linkName: $linkName, linkURL: $linkURL, ifEdit: true, products_number: productsNumber, linkEditShown: $linkEditShown, linkIndex: linkIndex, readData: readData).presentationDetents([.height(500)])
                }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        readData.products!.move(fromOffsets: source, toOffset: destination)
        withAnimation(.easeOut(duration: 0.25)) {
            isUpdating = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UpdateDB().updateIndex(products_input: readData.products!) { response in
                        if response == "Order Updated" {
                            withAnimation(.easeOut(duration: 0.25)) {
                                isUpdating = false
                            }
                        }
                    }
                }
    }
    
    func updateTempProducts() {
        let updatedProducts = Array(readData.products!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UpdateDB().updateIndex(products_input: updatedProducts) { response in
                if response == "Order Updated" {
                    print("Index changed")
                }
            }
        }
    }
}
