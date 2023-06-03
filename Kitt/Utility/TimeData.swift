//
//  TimeData.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation

class TimeData : ObservableObject {
    
    func getPresentDateTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    } 
}
