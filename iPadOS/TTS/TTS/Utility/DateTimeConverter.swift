//
//  IntToDateConverter.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/06.
//

import UIKit

struct DateTimeConverter {
    
    static func fromIntToString(input: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss"
        
        let date = Date(timeIntervalSince1970: TimeInterval(input))
        return dateFormatter.string(from: date)
    }
    
    static func fromIntToDate(input: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(input))
    }
    
    static func fromDateToHour(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd일 HH시"
        return dateFormatter.string(from: input)
    }
    
    static func fromDateToDay(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: input)
    }
    
    static func fromDateToMonth(input: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM"
        return dateFormatter.string(from: input)
    }
}
