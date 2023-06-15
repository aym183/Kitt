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
    @State var isShownHomePage: Bool
    @State var isChangesMade: Bool
    @State var isShownClassCreated: Bool
    @State var isShownProductCreated: Bool
    @State var isShownLinkCreated: Bool
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

    
    var body: some View {
        var noOfLinks = readData.links?.count ?? 0
        var noOfProducts = readData.products?.count ?? 0
        var noOfClasses = readData.classes?.count ?? 0
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    
                    if isShownHomePage {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Getting Kitt Ready! 🥳").font(Font.custom("Avenir-Medium", size: 20)).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isChangesMade {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Implementing Changes...").font(Font.custom("Avenir-Medium", size: 20)).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isShownLinkCreated {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Creating your link!").font(Font.custom("Avenir-Medium", size: 20)).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
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
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Creating your product!").font(Font.custom("Avenir-Medium", size: 20)).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
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
                                    
//                                    Image(uiImage: profile_image!)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 80, height: 80)
//                                        .cornerRadius(50)
                                } else {
                                    Image(systemName: "person.circle").font(Font.system(size: 80))
                                }
                            }
                            .padding(.top, 22)
                        }
                        .padding(.horizontal, 5)
                        
                        HStack {
                            Button(action: {
//                                linksNumber = noOfLinks
                                productsNumber = noOfProducts
                                classesNumber = noOfClasses
                                formShown.toggle()
//                                NotificationHandler().scheduleLocalNotification()
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
                        
                        if readData.products == nil {
                            Text("No products or links added yet.").fontWeight(.semibold)
                            Spacer()
                        } else {
//                            ScrollView(showsIndicators: false) {
//                                if readData.product_images != [] {
                            
                                
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
                                        //                                        HStack {
                                        
                                        if readData.products![index]["description"] != nil {
                                            ZStack {
                                                
                                                RoundedRectangle(cornerRadius: 10).fill(Color("TextField")).frame(width: max(0, geometry.size.width-50), height: 110)
                                                
                                                HStack {
                                                    ZStack {
                                                        Image(uiImage: readData.loadProductImage(key: readData.products![index]["image"]!)).resizable().scaledToFill()
                                                    }
                                                    .frame(width: 110, height: 110)
                                                    .cornerRadius(10)
//                                                    ////
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text("\(readData.products![index]["name"]!)").font(Font.custom("Avenir-Black", size: 15)).padding(.top, 5)
                                                        
                                                        Spacer()
                                                        
                                                        HStack {
                                                            
                                                            Text("\(readData.products![index]["price"]!) AED").font(Font.custom("Avenir-Medium", size: 15))
                                                            
                                                            Spacer()
                                                            
                                                            Button(action: {
                                                                
                                                                if temp_products != [] {
                                                                    if let product_index = temp_products.firstIndex(where: { $0["name"] == readData.products![index]["name"]! && $0["description"] == readData.products![index]["description"]! }) {
                                                                        
                                                                        productIndex = product_index
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
                                                                    }
                                                                } else {
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
                                                                }
                                                                
                                                            }) {
                                                                Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding(.trailing, 5).fontWeight(.bold)
                                                            }
                                                        }
                                                        .padding(.trailing, 10)
                                                        .padding(.bottom, 10)
                                                    }
                                                    .frame(height: 110)
                                                    .padding(.horizontal, 5)
//                                                    .padding(.vertical, 5)
                                                    
                                                }
                                                
                                            }
                                            .padding(.bottom, 5)
                                            //                                            .padding(.top,10)
                                            .padding(.horizontal)
                                            .multilineTextAlignment(.leading)
                                            .id(readData.products![index]["index"])
                                            .background(.white)
                                            .listRowBackground(Color.white)
                                            //                                        .onAppear {
                                            //                                            linksNumber += 1
                                            //                                        }
                                            
                                        } else {
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10).fill(Color("TextField")).frame(width: max(0, geometry.size.width-50), height: 70)
                                                
                                                HStack {
                                                    Text(readData.products![index]["name"]!).foregroundColor(.black).font(Font.custom("Avenir-Medium", size: 15)).padding(.leading, 20)
                                                    
                                                    Spacer()
                                                    
                                                    Button(action: {
                                                        if temp_products != [] {
                                                            if let link_index = temp_products.firstIndex(where: { $0["name"] == readData.products![index]["name"]! && $0["url"] == readData.products![index]["url"]! }) {
                                                                
                                                                linkIndex = link_index
                                                                linkName = readData.products![index]["name"]!
                                                                linkURL = readData.products![index]["url"]!
                                                                oldName = readData.products![index]["name"]!
                                                                oldURL = readData.products![index]["url"]!
                                                                linkEditShown.toggle()
                                                            }
                                                        } else {
                                                            linkIndex = index
                                                            linkName = readData.products![index]["name"]!
                                                            linkURL = readData.products![index]["url"]!
                                                            oldName = readData.products![index]["name"]!
                                                            oldURL = readData.products![index]["url"]!
                                                            linkEditShown.toggle()
                                                        }
//                                                        temp_products = readData.products!
                                                        
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
                                
//                                ForEach(0..<noOfClasses, id: \.self) { index in
//                                    HStack {
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2).frame(width: geometry.size.width-70, height: 310)
//                                                Spacer()
//
//                                            Image(uiImage: readData.loadProductImage(key: readData.classes![index]["image"]!)).resizable().frame(width: geometry.size.width-70, height: 170).cornerRadius(10).scaledToFit().padding(.top, -150)
//
//
//                                            VStack(alignment: .leading) {
//                                                HStack {
//                                                    Spacer()
//                                                    Button(action: {
//                                                        classIndex = index
//                                                        classDuration = readData.classes![index]["duration"]!
//                                                        classSeats = readData.classes![index]["seats"]!
//                                                        classLocation = readData.classes![index]["location"]!
//                                                        className = readData.classes![index]["name"]!
//                                                        classDesc = readData.classes![index]["description"]!
//                                                        classPrice = readData.classes![index]["price"]!
//
//                                                        oldClassDuration = readData.classes![index]["duration"]!
//                                                        oldClassSeats = readData.classes![index]["seats"]!
//                                                        oldClassLocation = readData.classes![index]["location"]!
//                                                        oldClassName = readData.classes![index]["name"]!
//                                                        oldClassDesc = readData.classes![index]["description"]!
//                                                        oldClassPrice = readData.classes![index]["price"]!
//
//                                                        oldClassImage = readData.loadProductImage(key: readData.classes![index]["image"]!)
//                                                        classImage = readData.loadProductImage(key: readData.classes![index]["image"]!)
//                                                        classEditShown.toggle()
//
//                                                    }) {
//                                                        Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding([.top, .trailing]).fontWeight(.bold)
//                                                    }
//
////                                                    Button(action: {
////                                                        productIndex = index
////                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////                                                            DeleteDB().deleteProduct(image: readData.products![productIndex]["image"]!)
////                                                            readData.products?.remove(at: productIndex)
////                                                        }
////                                                    }) {
////                                                        Image(systemName: "trash").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).foregroundColor(.red).padding([.top, .trailing]).fontWeight(.bold)
////                                                    }
////                                                    .font(Font.system(size: 13))
////                                                    .padding(.top, 5).padding(.trailing)
////                                                    .fontWeight(.bold)
//                                            }
//                                            .padding(.top, -5)
//
//                                            Spacer()
////                                                HStack {
//                                                    VStack(alignment: .leading) {
//
//                                                        Text(readData.classes![index]["name"]!).font(Font.system(size: 17)).fontWeight(.heavy).padding(.bottom, 5)
//
//                                                        Text("\(readData.classes![index]["price"]!) AED").font(Font.system(size: 15)).fontWeight(.medium).padding(.top, -2).padding(.bottom, 5)
//
//                                                        HStack {
//                                                            Image(systemName: "clock")
//                                                            Text("\(readData.classes![index]["duration"]!) mins").padding(.leading, 2)
//                                                        }
//                                                        .font(Font.system(size: 15))
//                                                        .padding(.bottom, 2)
//
//                                                        HStack {
//                                                            Image(systemName: "mappin")
//                                                            Text("\(readData.classes![index]["location"]!)").padding(.leading, 5)
//                                                        }
//                                                        .font(Font.system(size: 15))
//                                                        .padding(.bottom)
//                                                    }
//                                                    .padding(.leading, 15).padding(.top, -10)
////                                                    Spacer()
////                                                }
////                                                .frame(width: geometry.size.width-100, height: 100).padding(.leading)
//                                            }
//                                        }
//                                        .padding(.top,10)
//                                        .padding(.horizontal).padding(.trailing, 10)
//                                        .multilineTextAlignment(.leading)
//
//                                    }
//                                    .id(index)
//                                }
//                                .padding(.top, 10)
                                
//                            }
//                            .padding(.vertical)
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
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .onAppear {
                        readData.sales = []
                        DispatchQueue.global(qos: .userInteractive).async {
                            readData.getProducts()
                            //readData.getSales()
//                            readData.getClasses()
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
                                    temp_products = readData.products!
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isShownProductCreated = false
                                    isShownClassCreated = false
                                    temp_products = readData.products!
                                }
                            }
                        }
                    }
//                    .onChange(of: readData.products) { _ in
//                        print(readData.products)
//                    }
                    
                    .opacity(isShownHomePage ? 0 : 1)
                    .opacity(isShownProductCreated ? 0 : 1)
                    .opacity(isShownLinkCreated ? 0 : 1)
                    .opacity(isShownClassCreated ? 0 : 1)
                    .opacity(isChangesMade ? 0 : 1)
                }
                .navigationDestination(isPresented: $productEditShown) {
                    ProductForm(oldIndex: $oldProductIndex, oldProductName: $oldProductName, oldProductDesc: $oldProductDesc, oldProductPrice: $oldProductPrice, oldImage: $oldImage, oldFile: $oldFile, oldFileName: $oldFileName, productName: $productName, productDesc: $productDesc, productPrice: $productPrice, image: $image, file: $file, fileName: $fileName, products_number: productsNumber, ifEdit: true, productIndex: productIndex, readData: readData)
                }
//                .navigationDestination(isPresented: $classEditShown) {
//                    ClassForm(oldClassName: $oldClassName, oldClassDesc: $oldClassDesc, oldClassPrice: $oldClassPrice, oldClassDuration: $oldClassDuration, oldClassSeats: $oldClassSeats, oldClassLocation: $oldClassLocation, oldImage: $oldClassImage, className: $className, classDesc: $classDesc, classDuration: $classDuration, classPrice: $classPrice, classSeats: $classSeats, classLocation: $classLocation, image: $classImage, classes_number: classesNumber, ifEdit: true, classIndex: classIndex, readData: readData)
//                }
                .navigationDestination(isPresented: $linkEditShown) {
                    LinkForm(oldName: $oldName, oldURL: $oldURL, oldIndex: $oldLinkIndex, linkName: $linkName, linkURL: $linkURL, ifEdit: true, products_number: productsNumber, linkEditShown: $linkEditShown, linkIndex: linkIndex, readData: readData).presentationDetents([.height(500)])
                }
//                .alert(isPresented: $showingSignOutConfirmation) {
//                    Alert(
//                        title: Text("Are you sure you want to delete this?"),
//                        primaryButton: .default(Text("Yes")) {
//                            AuthViewModel().signOut() { response in
//                                if response == "Successful" {
//                                    signedOut.toggle()
//                                }
//                            }
//                            showingSignOutConfirmation = false
//                        },
//                        secondaryButton: .cancel() {
//                            showingSignOutConfirmation = false
//                        }
//                    )
//                }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
//        readData.products = []
        temp_products.move(fromOffsets: source, toOffset: destination)
//        readData.products!.move(fromOffsets: source, toOffset: destination)
//        readData.products = temp_products
//
        var currentIndex = 0
        for index in temp_products.indices {
            temp_products[index]["index"] = String(describing: currentIndex)
            currentIndex += 1
        }
        
//        let temp_index = readData.products![destination][
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UpdateDB().updateIndex(products_input: temp_products) { response in
                print("Index changed")
            }
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
