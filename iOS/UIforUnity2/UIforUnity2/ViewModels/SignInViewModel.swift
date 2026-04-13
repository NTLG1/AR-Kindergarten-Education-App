//
//  SignInViewModel.swift
//  UIforUnity2
//
//  Created by NTLG1 on 15/10/24.
//

import Foundation
import Combine

class SignInViewModel {
    
    var cancellables = Set<AnyCancellable>()

    // Function to sign in using the Endpoint enum
    func signIn(userRequest: SignInUserRequest) -> AnyPublisher<String, Error> {
        // Create the sign-in endpoint using the provided user request
        guard let request = Endpoint.signIn(userRequest: userRequest).request else {
            return Fail(error: ServiceError.serverError("Invalid URL request")).eraseToAnyPublisher()
        }
        
        // Use the authService to make the network call
        return AuthService2.fetch(request: request)
    }
}
