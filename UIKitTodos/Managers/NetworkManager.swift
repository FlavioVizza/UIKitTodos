//
//  NetworkManager.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import UIKit

/// A manager for handling network requests.
///
/// This class provides methods for performing HTTP requests and managing authentication headers.
class NetworkManager {

    /// The navigation manager used for handling navigation flow.
    private let navManager = NavigationManager.shared
    
    /// The base URL for network requests.
    private var baseUrl = ""
    /// The JSON decoder used for decoding JSON responses.
    let decoder = JSONDecoder()
    
    /// The shared instance of the NetworkManager.
    static let shared = NetworkManager()
    
    /// Initializes a new instance of the NetworkManager.
    ///
    /// This private initializer is called to create a new instance of the NetworkManager.
    private init() { }
    
    /// Performs an HTTP request.
    ///
    /// This method performs an HTTP request to the specified endpoint with the given method and optional request body.
    ///
    /// - Parameters:
    ///   - endpoint: The URL endpoint for the request.
    ///   - method: The HTTP method for the request.
    ///   - httpBody: The optional request body.
    ///   - withAuth: A flag indicating whether to include authentication headers in the request. Default is `false`.
    /// - Returns: A tuple containing the response data and URL response.
    func performHTTPRequest(endpoint: String, method: String, httpBody: Data? = nil, withAuth: Bool = false) async throws -> (Data, URLResponse) {
        guard let url = URL(string: endpoint) else {
            throw MyError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        do {
            let (data, response) = try await (withAuth ? performAuthRequest(request) : URLSession.shared.data(for: request))
            return (data, response)
        } catch {
            throw error
        }
    }

    /// Performs an authenticated HTTP request.
    ///
    /// This method performs an authenticated HTTP request using the provided request.
    ///
    /// - Parameter req: The URLRequest to be authenticated.
    /// - Returns: A tuple containing the response data and URL response.
    private func performAuthRequest(_ req: URLRequest) async throws -> (Data, URLResponse) {
        var request = req
        addAuthorizationHeader(to: &request)
        let (data, response) = try await URLSession.shared.data(for: request)

        print("request: \(String(describing: request.allHTTPHeaderFields))")
        print("response: \(response)")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MyError.invalidData
        }

        switch httpResponse.statusCode {
            case 401, 403:
                print("unauthorized: \(response)")
            
                // Make a call to a refresh endpoint
                // WARNING: Do not declare local constant authService, otherwise a circular reference is created
                let refresh = try await AuthService.shared.refreshToken()
                print("try to refresh token")
                if !refresh {
                    print("refresh token not valid")
                    navManager.setRoot(viewControllerIdentifier: AppPages.Login)
                    throw MyError.noAuthToken
                }
            
                return try await performAuthRequest(request)
            default:
                return (data, response)
        }
    }
    
    /// Adds authorization header to the request.
    ///
    /// This method adds the authorization header with the access token to the provided request.
    ///
    /// - Parameter request: The inout URLRequest to which the authorization header is to be added.
    private func addAuthorizationHeader(to request: inout URLRequest){
        let token = AuthManager.shared.accessToken ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    /// Simulates a network request.
    ///
    /// This method simulates a network request with an asynchronous delay.
    ///
    /// - Parameter sec: asynchronous delay in seconds
    /// - Returns: `true` if the simulated request is successful, `false` otherwise.
    func simulateRequest(sec: UInt64) async throws -> Bool {
        try await Task.sleep(nanoseconds: sec*1000_000_000)
        return true
    }
}

