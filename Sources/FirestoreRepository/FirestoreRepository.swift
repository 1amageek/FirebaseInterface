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

extension DocumentReference: DocumentPublishable {

    public func get<Document>() -> AnyPublisher<Document?, Error> where Document : Decodable {
        self.getDocument()
            .tryMap({ try $0?.data(as: Document.self)  })
            .eraseToAnyPublisher()
    }

    public func addDocumentListener<Document>() -> AnyPublisher<Document?, Error> where Document : Decodable {
        self.addSnapshotListener()
            .tryMap({ try $0?.data(as: Document.self)  })
            .eraseToAnyPublisher()
    }

    public func get<Document>(source: Source = .default) -> AnyPublisher<Document?, Error> where Document : Decodable {
        self.getDocument(source: source.rawValue)
            .tryMap({ try $0?.data(as: Document.self)  })
            .eraseToAnyPublisher()
    }

    public func addDocumentListener<Document>(includeMetadataChanges: Bool = false) -> AnyPublisher<Document?, Error> where Document : Decodable {
        self.addSnapshotListener(includeMetadataChanges: includeMetadataChanges)
            .tryMap({ try $0?.data(as: Document.self)  })
            .eraseToAnyPublisher()
    }

    public func getDocument(source: FirestoreSource = .default) -> AnyPublisher<DocumentSnapshot?, Error> {
        Future<DocumentSnapshot?, Error> { [weak self] promise in
            self?.getDocument(source: source) { (documentSnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(documentSnapshot))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func addSnapshotListener(includeMetadataChanges: Bool = false) -> AnyPublisher<DocumentSnapshot?, Error> {
        Future<DocumentSnapshot?, Error> { [weak self] promise in
            self?.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { (documentSnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(documentSnapshot))
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension Query: CollectionPublishable {

    public func get<Document>() -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        self.getDocument()
            .tryMap { try $0?.documents.compactMap({ try $0.data(as: Document.self) }) }
            .eraseToAnyPublisher()
    }

    public func addDocumentsListener<Document>() -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        self.addSnapshotListener()
            .tryMap { try $0?.documents.compactMap({ try $0.data(as: Document.self) }) }
            .eraseToAnyPublisher()
    }

    public func get<Document>(source: Source) -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        self.getDocument(source: source.rawValue)
            .tryMap { try $0?.documents.compactMap({ try $0.data(as: Document.self) }) }
            .eraseToAnyPublisher()
    }

    public func addDocumentsListener<Document>(includeMetadataChanges: Bool) -> AnyPublisher<[Document]?, Error> where Document : Decodable {
        self.addSnapshotListener(includeMetadataChanges: includeMetadataChanges)
            .tryMap { try $0?.documents.compactMap({ try $0.data(as: Document.self) }) }
            .eraseToAnyPublisher()
    }

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

    public func addSnapshotListener(includeMetadataChanges: Bool = false) -> AnyPublisher<QuerySnapshot?, Error> {
        Future<QuerySnapshot?, Error> { [weak self] promise in
            self?.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(querySnapshot))
                }
            }
        }.eraseToAnyPublisher()
    }
}
