//
//  ServerReponses.swift
//  UIforUnity2
//
//  Created by NTLG1 on 16/9/24.
//

import Foundation

struct SuccessResponse: Decodable {
    let success: String
}

struct ErrorResponse: Decodable {
    let error: String
}

struct DetailedErrorResponse: Decodable {
    let err: String
}
