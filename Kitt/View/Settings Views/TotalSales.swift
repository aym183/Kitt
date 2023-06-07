//
//  TotalSales.swift
//  Kitt
//
//  Created by Ayman Ali on 06/06/2023.
//

import SwiftUI

struct TotalSales: View {
    var labels = ["this week", "this month", "all-time"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    
                    HStack {
                        Text("Sales").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)
                        Spacer()
                    }
                    .padding(.leading, 15).padding(.bottom, -5).padding(.top, -5)
                    
                    TabView {
                        ForEach(0..<labels.count, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color("TextField"))
                                
                                VStack(alignment: .center) {
                                    
                                    Text(labels[index]).font(Font.custom("Avenir-Medium", size: 18))
                                    //                                Spacer()
                                    HStack(spacing: 2) {
                                        Text("450").font(Font.custom("Avenir-Heavy", size: 50)).fontWeight(.black)
                                        
                                        Text("aed").font(Font.custom("Avenir-Heavy", size: 25)).fontWeight(.black).padding(.bottom, -15)
                                    }
                                    .padding(.bottom, -20)
                                    
                                    Text("from 85 customers").font(Font.custom("Avenir-Medium", size:18))
                                }
                            }
                            .frame(width: geometry.size.width-70, height: 130)
                            .id(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .padding(.top, -50)
                    .frame(height: 180)
                    .onAppear {
                        setupAppearance()
                    }

                    
                    HStack {
                        Text("Orders").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)
                        Spacer()
                    }
                    .padding(.leading, 15).padding(.bottom, -5).padding(.top, -20)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text("05 June").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.045)).fontWeight(.bold).foregroundColor(.gray)
                                Spacer()
                            }
//                            .padding(.leading, 2)
                            
                            ForEach(0..<5, id: \.self) { index in
                                HStack(spacing: -5) {
                                    ZStack {
                                        Image("Test_Image")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Yoga Level 1 Guide")
                                            .font(Font.custom("Avenir-Heavy", size: 15))
                                        Text(verbatim: "imadali04@gmail.com")
                                            .font(Font.custom("Avenir-Medium", size: 14))
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 15)
//                                    .frame(width: 230)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 6) {
                                        Text("200 aed").font(Font.custom("Avenir-Heavy", size: 15)).fontWeight(.bold)
                                        
                                        Text("2h ago").font(Font.custom("Avenir-Medium", size: 14)).foregroundColor(.gray).fontWeight(.bold)
//                                        .padding(.trailing, 20.5)
                                    }
                                    .padding(.leading, -25)
                                }
                                .frame(width: geometry.size.width-70, height: 50)
                                .padding(.bottom, 5)
//                                .padding(.horizontal, 15)
                                
                            }
                        }
//                        .padding(.leading, 15)
                        .padding(.horizontal, 15)
                        
                    }
                    .padding(.top, -15)
                }
                .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                .foregroundColor(.black)
            }
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
      }
}

struct TotalSales_Previews: PreviewProvider {
    static var previews: some View {
        TotalSales()
    }
}
