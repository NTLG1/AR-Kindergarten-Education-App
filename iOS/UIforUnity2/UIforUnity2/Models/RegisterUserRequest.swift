//
//  RegisterUserRequest.swift
//  UIforUnity2
//
//  Created by NTLG1 on 16/9/24.
//

import Foundation

struct RegisterUserRequest: Codable {
    let email: String
    let username: String
    let password: String
}
