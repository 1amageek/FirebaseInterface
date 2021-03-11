//
//  File.swift
//  
//
//  Created by nori on 2021/03/11.
//

import Foundation
import Combine
import FirestoreProtocol
import FirebaseFirestore
import FirebaseFirestoreSwift


extension DocumentReference {

    struct Publisher: Combine.Publisher {

        typealias Output = DocumentSnapshot
        
        typealias Failure = Error

        private let documentReference: DocumentReference

        private let includeMetadataChanges: Bool

        init(_ documentReference: DocumentReference, includeMetadataChanges: Bool) {
            self.documentReference = documentReference
            self.includeMetadataChanges = includeMetadataChanges
        }

        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = DocumentSnapshot.Subscription(subscriber: subscriber, documentReference: documentReference, includeMetadataChanges: includeMetadataChanges)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension DocumentReference: DocumentPublishable {

    public func getDocument(source: FirestoreSource = .default) -> AnyPublisher<DocumentSnapshot, Error> {
        Future<DocumentSnapshot, Error> { [weak self] promise in
            self?.getDocument(source: source) { (documentSnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let documentSnapshot = documentSnapshot {
                    promise(.success(documentSnapshot))
                } else {
                    promise(.failure(FirestoreError.nilResultError))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func get<Document>() -> AnyPublisher<Document?, Error> where Document : Decodable {
        getDocument()
            .tryMap({ try $0.data(as: Document.self)  })
            .eraseToAnyPublisher()
    }

    public func get<Document>(source: Source = .default) -> AnyPublisher<Document?, Error> where Document : Decodable {
        getDocument(source: source.rawValue)
            .tryMap({ try $0.data(as: Document.self)  })
            .eraseToAnyPublisher()
    }

    public func publisher<Document>() -> AnyPublisher<Document?, Error> where Document : Decodable {
        publisher(includeMetadataChanges: false)
    }

    public func publisher<Document>(includeMetadataChanges: Bool = false) -> AnyPublisher<Document?, Error> where Document : Decodable {
        publisher(includeMetadataChanges: includeMetadataChanges)
            .tryMap({ try $0.data(as: Document.self)  })
            .eraseToAnyPublisher()
    }

    public func publisher(includeMetadataChanges: Bool = false) -> AnyPublisher<DocumentSnapshot, Error> {
        DocumentReference.Publisher(self, includeMetadataChanges: includeMetadataChanges).eraseToAnyPublisher()
    }
}

