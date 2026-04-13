//
//  AuthService.swift
//  UIforUnity2
//
//  Created by NTLG1 on 16/9/24.
//

import Combine
import Foundation

enum ServiceError: Error {
    case serverError(String)
    case unknown(String = "An unknown error occurred.")
    case decodingError(String = "Error parsing server response.")
}

class AuthService {

    // MARK: - Fetch Method
    static func fetch(request: URLRequest, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Log the request URL
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        
        // Log the request body
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        } else {
            print("Request Body is empty")
        }

        // Ensure that Content-Type and Accept headers are set
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Start the URLSession task
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Log the response
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }

            // Log the response body
            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseBody)")
            }
            
            // Check for errors in the request
            guard let data = data else {
                if let error = error {
                    completion(.failure(ServiceError.serverError(error.localizedDescription)))
                } else {
                    completion(.failure(ServiceError.unknown()))
                }
                return
            }
            
            let decoder = JSONDecoder()

            // Try decoding a successful response
            if let successMessage = try? decoder.decode(SuccessResponse.self, from: data) {
                completion(.success(successMessage.success))
                return
            }
            // Try decoding an error response with a detailed error field
            else if let errorMessage = try? decoder.decode(DetailedErrorResponse.self, from: data) {
                completion(.failure(ServiceError.serverError(errorMessage.err)))
                return
            }
            // Decoding failure
            else {
                completion(.failure(ServiceError.decodingError()))
                return
            }
        }.resume()
    }
    
    
    // MARK: - Sign Out
    static func signOut() {
        let url = URL(string: Constants.fullURL)!
        if let cookie = HTTPCookieStorage.shared.cookies(for: url)?.first {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        } else {
            print("No cookies found for URL: \(url)")
        }
    }

}

class AuthService2 {
    
    // MARK: - Fetch Method (Using Combine)
    static func fetch(request: URLRequest) -> AnyPublisher<String, Error> {
        // Log the request URL
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        
        // Log the request body
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        } else {
            print("Request Body is empty")
        }
        
        // Ensure that Content-Type and Accept headers are set
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Return a Combine publisher
        return Future<String, Error> { promise in
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Log the response
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response Status Code: \(httpResponse.statusCode)")
                    print("Response Headers: \(httpResponse.allHeaderFields)")
                }
                
                // Log the response body
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
                
                // Handle the network error case
                guard let data = data else {
                    if let error = error {
                        promise(.failure(ServiceError.serverError(error.localizedDescription)))
                    } else {
                        promise(.failure(ServiceError.unknown()))
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                
                // Try decoding a successful response
                if let successMessage = try? decoder.decode(SuccessResponse.self, from: data) {
                    promise(.success(successMessage.success))
                }
                // Try decoding an error response with a detailed error field
                else if let errorMessage = try? decoder.decode(DetailedErrorResponse.self, from: data) {
                    promise(.failure(ServiceError.serverError(errorMessage.err)))
                }
                // Decoding failure
                else {
                    promise(.failure(ServiceError.decodingError()))
                }
            }.resume()
        }
        .eraseToAnyPublisher()
    }
}
