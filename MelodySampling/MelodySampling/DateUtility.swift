//
//  DateUtility.swift
//  King of Song Quiz
//
//  Created by moon on 2018/2/24.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation

class DateUtility {
    
    class func getYear(from date: Date) -> Int {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.year, from: date)
        return weekOfYear
    }
    
    class func getWeekOfYear(from date: Date) -> Int {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        return weekOfYear
    }
    
    class func getStrDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
