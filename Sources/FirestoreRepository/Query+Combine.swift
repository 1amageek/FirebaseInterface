//
//  Query+Combine.swift
//  
//
//  Created by nori on 2021/03/11.
//

import Foundation
import Combine
import FirestoreProtocol
import FirebaseFirestore
import FirebaseFirestoreSwift


extension Query {

    struct Publisher: Combine.Publisher {

        typealias Output = QuerySnapshot

        typealias Failure = Error

        private let query: Query

        private let includeMetadataChanges: Bool

        init(_ query: Query, includeMetadataChanges: Bool) {
            self.query = query
            self.includeMetadataChanges = includeMetadataChanges
        }

        func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = QuerySnapshot.Subscription(subscriber: subscriber, query: query, includeMetadataChanges: includeMetadataChanges)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension Query: CollectionPublishable {

    public func getDocument(source: FirestoreSource = .default) -> AnyPublisher<QuerySnapshot?, Error> {
        Future<QuerySnapshot?, Error> { [weak self] promise in
            self?.getDocuments(source: source, completion: { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(querySnapshot))
                }
            })
        }.eraseToAnyPublisher()
    }

    public func get<Document>(as type: Document.Type) -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        getDocument()
            .tryMap { try $0?.documents.compactMap({ try $0.data(as: type) }) }
            .eraseToAnyPublisher()
    }

    public func get<Document>(source: Source, as type: Document.Type) -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        getDocument(source: source.rawValue)
            .tryMap { try $0?.documents.compactMap({ try $0.data(as: type) }) }
            .eraseToAnyPublisher()
    }

    public func publisher<Document>(as type: Document.Type) -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        publisher(includeMetadataChanges: true, as: type)
    }

    public func publisher<Document>(includeMetadataChanges: Bool = true, as type: Document.Type) -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        publisher(includeMetadataChanges: includeMetadataChanges)
            .tryMap { try $0.documents.compactMap({ try $0.data(as: type) }) }
            .eraseToAnyPublisher()
    }

    public func publisher(includeMetadataChanges: Bool = true) -> AnyPublisher<QuerySnapshot, Error> {
        Query.Publisher(self, includeMetadataChanges: includeMetadataChanges).eraseToAnyPublisher()
    }
}
