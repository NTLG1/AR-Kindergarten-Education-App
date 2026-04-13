//
//  HTTP.swift
//  UIforUnity2
//
//  Created by NTLG1 on 16/9/24.
//

import Foundation

enum HTTP {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Headers {
        
        enum Key: String {
            case contentType = "Constant-Type"
        }
        
        enum Value: String {
            case applicationJson = "application/json"
        }
    }
}
