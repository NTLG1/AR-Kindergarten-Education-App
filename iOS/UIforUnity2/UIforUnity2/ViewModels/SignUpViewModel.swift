//
//  SignUpViewModel.swift
//  UIforUnity2
//
//  Created by NTLG1 on 15/10/24.
//

import Combine
import Foundation

class SignUpViewModel {
    
    var cancellables = Set<AnyCancellable>()
    
    // Function to sign up using the Endpoint enum
    func signUp(userRequest: RegisterUserRequest) -> AnyPublisher<String, Error> {
        // Create the sign-up endpoint using the provided user request
        guard let request = Endpoint.createAccount(userRequest: userRequest).request else {
            return Fail(error: ServiceError.serverError("Invalid URL request")).eraseToAnyPublisher()
        }
        
        // Use the static `fetch` method from AuthService
        return AuthService2.fetch(request: request)
    }
}


