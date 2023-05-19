//
//  ContentView.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

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
    @State var oldProductName = ""
    @State var oldProductDesc = ""
    @State var oldProductPrice = ""
    @State var oldImage: UIImage?
    @State var productName = ""
    @State var productDesc = ""
    @State var productPrice = ""
    @State var image: UIImage?
    @State var oldClassName = ""
    @State var oldClassDesc = ""
    @State var oldClassPrice = ""
    @State var oldClassSeats = ""
    @State var oldClassLocation = ""
    @State var oldClassDuration = ""
    @State var oldClassImage: UIImage?
    @State var className = ""
    @State var classDesc = ""
    @State var classDuration = ""
    @State var classPrice = ""
    @State var classSeats = ""
    @State var classLocation = ""
    @State var classImage: UIImage?
    
    @State var oldName = ""
    @State var oldURL = ""
    @State var linkName = ""
    @State var linkURL = ""
    @State var linksNumber = 0
    @State var productsNumber = 0
    @State var classesNumber = 0
    @State var productIndex = 0
    @State var linkIndex = 0
    @State var profile_image: UIImage?
    @State var productEditShown = false
    @State var classEditShown = false
    @State var linkEditShown = false
    @State var socialsEditShown = false

    
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
                            
                            Text("Getting Kitt Ready! 🥳").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isChangesMade {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Implementing Changes...").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isShownLinkCreated {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Creating your link!").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isShownClassCreated {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Creating your class!").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isShownProductCreated {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Creating your product!").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("kitt.bio/\(userName)").font(Font.system(size: 20)).fontWeight(.bold)
                                
                                HStack(spacing: 25) {
                                    Button(action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = "kitt.bio/\(userName)"
                                    }) {
                                        Image(systemName: "doc").background(
                                            Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                        )
                                    }
                                    
                                    Button(action: {}) {
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
                            
                            Button(action: {settingsShown.toggle()}) {
                                
                                if profile_image != nil {
                                    Image(uiImage: profile_image!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(50)
                                } else {
                                    Image(systemName: "person.circle").font(Font.system(size: 60))
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        HStack {
                            Button(action: {
                                linksNumber = noOfLinks
                                productsNumber = noOfProducts
                                classesNumber = noOfClasses
                                formShown.toggle()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                    Text("Add")
                                }
                                .frame(width: 85, height: 35).padding(4).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10).padding(.top)
                        
                        
                        Spacer()
                        
                        if readData.links == nil && readData.products == nil{
                            Text("No products or links added yet.").fontWeight(.semibold)
                            Spacer()
                        } else {
                            ScrollView(showsIndicators: false) {
//                                if readData.product_images != [] {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-70, height: 60).foregroundColor(.gray).opacity(0.2)
                                    
                                    HStack {
                                        Text("😎  Your Social Links").foregroundColor(.black).font(Font.system(size: 15)).fontWeight(.medium).padding(.leading, 22)
                                        
                                        Spacer()
                                        
                                        Button(action: { socialsEditShown.toggle() }) {
                                            Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).fontWeight(.bold)
//                                                .padding(.trailing, 10)
                                        }
                                    }
                                    .padding(.trailing)
                                }
                                .padding(.horizontal).padding(.trailing, 10)
                                .multilineTextAlignment(.leading)
                                
                                
                                ForEach(0..<noOfClasses, id: \.self) { index in
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-70, height: 310).foregroundColor(.gray).opacity(0.2)
                                                Spacer()
                                            
                                            Image(uiImage: readData.loadProductImage(key: readData.classes![index]["image"]!)).resizable().frame(width: geometry.size.width-70, height: 170).cornerRadius(10).scaledToFit().padding(.top, -150)
                                            
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        classDuration = readData.classes![index]["duration"]!
                                                        classSeats = readData.classes![index]["seats"]!
                                                        classLocation = readData.classes![index]["location"]!
                                                        className = readData.classes![index]["name"]!
                                                        classDesc = readData.classes![index]["description"]!
                                                        classPrice = readData.classes![index]["price"]!
                                                        
                                                        oldClassDuration = readData.classes![index]["duration"]!
                                                        oldClassSeats = readData.classes![index]["seats"]!
                                                        oldClassLocation = readData.classes![index]["location"]!
                                                        oldClassName = readData.classes![index]["name"]!
                                                        oldClassDesc = readData.classes![index]["description"]!
                                                        oldClassPrice = readData.classes![index]["price"]!
                                                        
                                                        oldClassImage = readData.loadProductImage(key: readData.classes![index]["image"]!)
                                                        classImage = readData.loadProductImage(key: readData.classes![index]["image"]!)
                                                        classEditShown.toggle()
                                                   
                                                    }) {
                                                        Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding([.top, .trailing]).fontWeight(.bold)
                                                    }
                                                    
//                                                    Button(action: {
//                                                        productIndex = index
//                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                                            DeleteDB().deleteProduct(image: readData.products![productIndex]["image"]!)
//                                                            readData.products?.remove(at: productIndex)
//                                                        }
//                                                    }) {
//                                                        Image(systemName: "trash").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).foregroundColor(.red).padding([.top, .trailing]).fontWeight(.bold)
//                                                    }
//                                                    .font(Font.system(size: 13))
//                                                    .padding(.top, 5).padding(.trailing)
//                                                    .fontWeight(.bold)
                                            }
                                            .padding(.top, -5)
                                                
                                            Spacer()
//                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        
                                                        Text(readData.classes![index]["name"]!).font(Font.system(size: 17)).fontWeight(.heavy).padding(.bottom, 5)
                                                        
                                                        Text("\(readData.classes![index]["price"]!) AED").font(Font.system(size: 15)).fontWeight(.medium).padding(.top, -2).padding(.bottom, 5)
                                                        
                                                        HStack {
                                                            Image(systemName: "clock")
                                                            Text("\(readData.classes![index]["duration"]!) mins").padding(.leading, 2)
                                                        }
                                                        .font(Font.system(size: 15))
                                                        .padding(.bottom, 2)
                                                        
                                                        HStack {
                                                            Image(systemName: "mappin")
                                                            Text("\(readData.classes![index]["location"]!)").padding(.leading, 5)
                                                        }
                                                        .font(Font.system(size: 15))
                                                        .padding(.bottom)
                                                    }
                                                    .padding(.leading, 15).padding(.top, -10)
//                                                    Spacer()
//                                                }
//                                                .frame(width: geometry.size.width-100, height: 100).padding(.leading)
                                            }
                                        }
                                        .padding(.top,10)
                                        .padding(.horizontal).padding(.trailing, 10)
                                        .multilineTextAlignment(.leading)

                                    }
                                    .id(index)
                                }
                                .padding(.top, 10)
                                
                                    ForEach(0..<noOfProducts, id: \.self) { index in
                                        HStack {
                                            ZStack {
                                                
                                                RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-70, height: 270).foregroundColor(.gray).opacity(0.2)
                                                    Spacer()
                                                
                                                Image(uiImage: readData.loadProductImage(key: readData.products![index]["image"]!)).resizable().frame(width: geometry.size.width-70, height: 190).cornerRadius(10).scaledToFit().padding(.top, -75)
                                                
                                                
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        Button(action: {
                                                            productName = readData.products![index]["name"]!
                                                            productDesc = readData.products![index]["description"]!
                                                            productPrice = "\(readData.products![index]["price"]!)"
                                                            oldProductName = readData.products![index]["name"]!
                                                            oldProductDesc = readData.products![index]["description"]!
                                                            oldProductPrice = "\(readData.products![index]["price"]!)"
                                                            oldImage = readData.loadProductImage(key: readData.products![index]["image"]!)
                                                            image = readData.loadProductImage(key: readData.products![index]["image"]!)
                                                            productEditShown.toggle()
                                                       
                                                        }) {
                                                            Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding([.top, .trailing]).fontWeight(.bold)
                                                        }
                                                        
//                                                        Button(action: {
//                                                            productIndex = index
//                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                                                DeleteDB().deleteProduct(image: readData.products![productIndex]["image"]!)
//                                                                readData.products?.remove(at: productIndex)
//                                                            }
//                                                        }) {
//                                                            Image(systemName: "trash").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).foregroundColor(.red).padding([.top, .trailing]).fontWeight(.bold)
//                                                        }
                                                        
//                                                    .font(Font.system(size: 13))
//                                                    .padding(.top, 5).padding(.trailing)
//                                                    .fontWeight(.bold)
                                                }
                                                    HStack {
                                                        VStack(alignment: .leading) {
                                                            Spacer()
                                                            Text( readData.products![index]["name"]!).font(Font.system(size: 17)).fontWeight(.heavy)
                                                            
                                                            Text("\(readData.products![index]["price"]!) AED").font(Font.system(size: 15)).fontWeight(.medium).padding(.top, -2)
                                                        }
                                                        .padding(.leading, 15).padding(.bottom, 10)
                                                        Spacer()
                                                    }
                                                }
                                                
                                                
                                            }
                                            .padding(.top,10)
                                            .padding(.horizontal).padding(.trailing, 10)
                                            .multilineTextAlignment(.leading)
                                            
//                                            HStack(spacing: 25) {
//                                                Button(action: {
//                                                    productName = readData.products![index]["name"]!
//                                                    productDesc = readData.products![index]["description"]!
//                                                    productPrice = "\(readData.products![index]["price"]!)"
//                                                    oldProductName = readData.products![index]["name"]!
//                                                    oldProductDesc = readData.products![index]["description"]!
//                                                    oldProductPrice = "\(readData.products![index]["price"]!)"
//                                                    oldImage = readData.loadProductImage(key: readData.products![index]["image"]!)
//                                                    image = readData.loadProductImage(key: readData.products![index]["image"]!)
//                                                    productEditShown.toggle()
//
//                                                }) {
//                                                    Image(systemName: "pencil").background(
//                                                        Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
//                                                    )
//                                                }
//
//                                                Button(action: {
//                                                    productIndex = index
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                                        DeleteDB().deleteProduct(image: readData.products![productIndex]["image"]!)
//                                                        readData.products?.remove(at: productIndex)
//                                                    }
//                                                }) {
//                                                    Image(systemName: "trash").background(
//                                                        Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
//                                                    ).foregroundColor(.red)
//                                                }
//                                            }
//                                            .font(Font.system(size: 13))
//                                            .padding(.top, 5).padding(.trailing)
//                                            .fontWeight(.bold)
                                        }
                                        .id(index)
                                    }
                                    .padding(.top, 10)
                                    
//                                }
                                
                                
                                ForEach(0..<noOfLinks, id: \.self) { index in
//                                    HStack {
                                        ZStack {
                                                RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-70, height: 60).foregroundColor(.gray).opacity(0.2)
                                            
                                            HStack {
                                                Text( readData.links![index]["name"]!).foregroundColor(.black).font(Font.system(size: 15)).fontWeight(.medium).padding(.leading, 22)
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    linkName = readData.links![index]["name"]!
                                                    linkURL = readData.links![index]["url"]!
                                                    oldName = readData.links![index]["name"]!
                                                    oldURL = readData.links![index]["url"]!
                                                    linkEditShown.toggle()
                                                
                                                }) {
                                                    Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).fontWeight(.bold)
                                                }
                                                
//                                                Button(action: {
//                                                    linkIndex = index
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                                        DeleteDB().deleteLink(name: readData.links![index]["name"]!, url: readData.links![index]["url"]!)
//                                                        readData.links?.remove(at: linkIndex as Int)
//                                                    }
//                                                }) {
//                                                    Image(systemName: "trash").background(
//                                                        Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).foregroundColor(.red).fontWeight(.bold)
//                                                }
                                            }
                                            .padding(.trailing)
                                        }
                                        .padding(.horizontal).padding(.trailing, 10)
                                        .multilineTextAlignment(.leading)
                                        
//                                        HStack(spacing: 25) {
//                                            Button(action: {
//                                                linkName = readData.links![index]["name"]!
//                                                linkURL = readData.links![index]["url"]!
//                                                oldName = readData.links![index]["name"]!
//                                                oldURL = readData.links![index]["url"]!
//                                                linkEditShown.toggle()
//
//                                            }) {
//                                                Image(systemName: "pencil").background(
//                                                    Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
//                                                )
//                                            }
//
//                                            Button(action: {
//                                                linkIndex = index
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                                    DeleteDB().deleteLink(name: readData.links![index]["name"]!, url: readData.links![index]["url"]!)
//                                                        readData.links?.remove(at: linkIndex as Int)
//                                                }
//                                            }) {
//                                                Image(systemName: "trash").background(
//                                                    Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
//                                                ).foregroundColor(.red)
//                                            }
//                                        }
//                                        .font(Font.system(size: 13))
//                                        .padding(.top, 5).padding(.trailing)
//                                        .fontWeight(.bold)
//                                    }
                                    .id(index)
                                }
                                .padding(.top,10)
                                
//                                HStack {
//                                    Spacer()
//                                    Text("Made with")
//                                        .font(.footnote).fontWeight(.semibold)
//                                        .padding(.top).padding(.horizontal, 5)
//                                        .opacity(0.7)
//                                    Image("LaunchSets").resizable().frame(width: 50, height: 40).cornerRadius(10).padding(.top, 10).padding(.leading, -8)
//                                    Spacer()
//                                }
//                                .padding(.top)
                            }
                            .padding(.top)
                        }
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
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
                        DispatchQueue.global(qos: .userInteractive).async {
                            readData.getLinks()
                            readData.getProducts()
                            readData.getClasses()
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
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isShownProductCreated = false
                                    isShownClassCreated = false
                                }
                            }
                        }
                    }
                    .opacity(isShownHomePage ? 0 : 1)
                    .opacity(isShownProductCreated ? 0 : 1)
                    .opacity(isShownLinkCreated ? 0 : 1)
                    .opacity(isShownClassCreated ? 0 : 1)
                    .opacity(isChangesMade ? 0 : 1)
                }
                .navigationDestination(isPresented: $productEditShown) {
                    ProductForm(oldProductName: $oldProductName, oldProductDesc: $oldProductDesc, oldProductPrice: $oldProductPrice, oldImage: $oldImage, productName: $productName, productDesc: $productDesc, productPrice: $productPrice, image: $image, products_number: productsNumber, ifEdit: true, readData: readData)
                }
                .navigationDestination(isPresented: $classEditShown) {
                    ClassForm(oldClassName: $oldClassName, oldClassDesc: $oldClassDesc, oldClassPrice: $oldClassPrice, oldClassDuration: $oldClassDuration, oldClassSeats: $oldClassSeats, oldClassLocation: $oldClassLocation, oldImage: $oldClassImage, className: $className, classDesc: $classDesc, classDuration: $classDuration, classPrice: $classPrice, classSeats: $classSeats, classLocation: $classLocation, image: $classImage, classes_number: classesNumber, ifEdit: true)
                }
                .sheet(isPresented: $linkEditShown) {
                    LinkForm(oldName: $oldName, oldURL: $oldURL, linkName: $linkName, linkURL: $linkURL, ifEdit: true, links_number: linksNumber, linkEditShown: $linkEditShown, readData: readData).presentationDetents([.height(500)])
                }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
