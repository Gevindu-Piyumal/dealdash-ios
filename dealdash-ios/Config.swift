//
//  Config.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Foundation

enum Config {
    static let apiBaseURL = URL(string: "http://192.168.1.3:4000/api")!

    static let requestTimeout: TimeInterval = 30

    static let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        d.dateDecodingStrategy = .formatted(formatter)
        
        return d
    }()
}


