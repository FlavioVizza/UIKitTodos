//
//  GenericResponse.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 17/04/24.
//

import Foundation

/// A structure representing a generic response from the server.
///
/// This structure encapsulates information about the success status and message returned from an API call.
public struct GenericResponse: Codable {
    
    /// A Boolean value indicating the success status of the response.
    public let success: Bool
    
    /// A message providing additional information about the response.
    public let message: String
}
