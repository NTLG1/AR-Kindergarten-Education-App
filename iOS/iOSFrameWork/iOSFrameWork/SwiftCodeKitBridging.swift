//
//  SwiftCodeKitBridging.swift
//  iOSFrameWork
//
//  Created by NTLG1 on 5/5/24.
//

import Foundation

@_cdecl("startSwiftCodeKitController")
public func startSwiftCodeKitController() {
    SwiftCodeKit.start()
}
