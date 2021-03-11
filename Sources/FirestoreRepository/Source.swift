//
//  FirestoreRepository.swift
//  
//
//  Created by nori on 2021/02/18.
//

import Foundation
import Combine
import FirestoreProtocol
import FirebaseFirestore
import FirebaseFirestoreSwift


extension Source: RawRepresentable {

    public init?(rawValue: FirestoreSource) {
        switch rawValue {
            case .default: self = .default
            case .server: self = .server
            case .cache: self = .cache
            @unknown default: fatalError()
        }
    }

    public var rawValue: FirestoreSource {
        switch self {
            case .default: return .default
            case .server: return .server
            case .cache: return .cache
        }
    }
}
