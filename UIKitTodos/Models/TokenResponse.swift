//
//  TokenResponse.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import Foundation

/// A structure representing a response containing access and refresh tokens.
///
/// This structure encapsulates information about access and refresh tokens used for authentication.
public struct TokenResponse: Codable {
    
    /// The access token obtained from the server.
    public let accessToken: String
    
    /// The refresh token obtained from the server.
    public let refreshToken: String
}
