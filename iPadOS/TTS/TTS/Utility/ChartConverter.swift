//
//  ChartConverter.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/12.
//

import UIKit

enum ChartType {
    case hour, day, month
}

struct ChartConverter {
    struct Data {
        var date: Date
        var price: Double
    }
    
    struct Day {
        var date: String
        var priceList: [Double]
    }
    
    static func getHourly(input: [TransactionModel]) -> ChartModel {
        var dataList = [Data]()
        input.forEach {
            dataList.append(Data(
                date: DateTimeConverter.fromIntToDate(input: $0.Transaction.registeredDate),
                price: Double($0.Transaction.price)))
        }
        dataList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        
        var convertedList = [Day]()
        
        dataList.enumerated().forEach { (index, data) in
            let currentDate = DateTimeConverter.fromDateToHour(input: data.date)
            let price = data.price
            if convertedList.isEmpty {
                convertedList.append(Day(date: currentDate, priceList: [price]))
            } else {
                let latest = convertedList[convertedList.count - 1]
                if latest.date == currentDate {
                    convertedList[convertedList.count - 1].priceList.append(price)
                } else {
                    convertedList.append(Day(date: currentDate, priceList: [price]))
                }
            }
        }
        
        let count = convertedList.count
        var xData = [String]()
        var yData = [Double]()
        let average: Double = 0.0
        
        convertedList.forEach { item in
            xData.append(item.date)
            var temp = 0.0
            item.priceList.forEach { temp += $0 }
            temp /= Double(item.priceList.count)
            print(temp)
            yData.append(temp)
        }
        
        return ChartModel(count: count, xData: xData, yData: yData, average: average)
    }
    
    static func getDaily(input: [TransactionModel]) -> ChartModel {
        var dataList = [Data]()
        input.forEach {
            dataList.append(Data(
                date: DateTimeConverter.fromIntToDate(input: $0.Transaction.registeredDate),
                price: Double($0.Transaction.price)))
        }
        dataList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        
        var convertedList = [Day]()
        
        dataList.enumerated().forEach { (index, data) in
            let currentDate = DateTimeConverter.fromDateToDay(input: data.date)
            let price = data.price
            if convertedList.isEmpty {
                convertedList.append(Day(date: currentDate, priceList: [price]))
            } else {
                let latest = convertedList[convertedList.count - 1]
                if latest.date == currentDate {
                    convertedList[convertedList.count - 1].priceList.append(price)
                } else {
                    convertedList.append(Day(date: currentDate, priceList: [price]))
                }
            }
        }
        
        let count = convertedList.count
        var xData = [String]()
        var yData = [Double]()
        let average: Double = 0.0
        
        convertedList.forEach { item in
            xData.append(item.date)
            var temp = 0.0
            item.priceList.forEach { temp += $0 }
            temp /= Double(item.priceList.count)
            print(temp)
            yData.append(temp)
        }
        
        return ChartModel(count: count, xData: xData, yData: yData, average: average)
    }
    
    static func getMonthly(input: [TransactionModel]) -> ChartModel {
        var dataList = [Data]()
        input.forEach {
            dataList.append(Data(
                date: DateTimeConverter.fromIntToDate(input: $0.Transaction.registeredDate),
                price: Double($0.Transaction.price)))
        }
        dataList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
        
        var convertedList = [Day]()
        
        dataList.enumerated().forEach { (index, data) in
            let currentDate = DateTimeConverter.fromDateToMonth(input: data.date)
            let price = data.price
            if convertedList.isEmpty {
                convertedList.append(Day(date: currentDate, priceList: [price]))
            } else {
                let latest = convertedList[convertedList.count - 1]
                if latest.date == currentDate {
                    convertedList[convertedList.count - 1].priceList.append(price)
                } else {
                    convertedList.append(Day(date: currentDate, priceList: [price]))
                }
            }
        }
        
        let count = convertedList.count
        var xData = [String]()
        var yData = [Double]()
        let average: Double = 0.0
        
        convertedList.forEach { item in
            xData.append(item.date)
            var temp = 0.0
            item.priceList.forEach { temp += $0 }
            temp /= Double(item.priceList.count)
            print(temp)
            yData.append(temp)
        }
        
        return ChartModel(count: count, xData: xData, yData: yData, average: average)
    }
}
