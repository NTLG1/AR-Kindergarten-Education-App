//
//  ForgotPasswordViewModel.swift
//  UIforUnity2
//
//  Created by NTLG1 on 15/10/24.
//

import Combine
import Foundation

class ForgotPasswordViewModel {
    
    var cancellables = Set<AnyCancellable>()
    
    // Function to send a password reset request using the Endpoint enum
    func forgotPassword(email: String) -> AnyPublisher<Void, Error> {
        guard let request = Endpoint.forgotPassword(email: email).request else {
            return Fail(error: ServiceError.serverError("Invalid URL request")).eraseToAnyPublisher()
        }
        
        // Use the static `fetch` method from AuthService
        return AuthService2.fetch(request: request)
            .map { _ in () } // Convert the String success message to Void
            .eraseToAnyPublisher()
    }
}

