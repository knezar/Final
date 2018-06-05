//
//  Models.swift
//  AC-iOS 4.3 Final-Retake - Practical
//
//  Created by C4Q on 6/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//
import Foundation

struct Task: Codable {
    let email: String
    let text: String
    let timestamp: Double
    let type: String
    let userId: String
    //Will convert into dictionary where keys are indicies
    //let arr: [String] = ["test", "strings", "are", "here"]
    func toJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}
class Models {
    func getDateFormatted(from date: Double, format: String) -> String{
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let stringFromDate = dateFormatter.string(from: date)
        return stringFromDate
    }
}
