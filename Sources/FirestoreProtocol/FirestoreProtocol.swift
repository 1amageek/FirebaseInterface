//
//  File.swift
//  
//
//  Created by nori on 2021/02/18.
//

import Foundation
import Combine

public enum Source {
    case `default`
    case server
    case cache
}

public protocol DocumentReferencePublishable {
    func get<Document: Decodable>(source: Source) -> AnyPublisher<Document?, Error>
    func addDocumentListener<Document: Decodable>(includeMetadataChanges: Bool) -> AnyPublisher<Document?, Error>
}

public protocol QueryPublishable {
    func get<Document: Decodable>(source: Source) -> AnyPublisher<[Document]?, Error>
    func addDocumentsListener<Document: Decodable>(includeMetadataChanges: Bool) -> AnyPublisher<[Document]?, Error>
}

public protocol DocumentReferenceWritable {
    func setData<T: Encodable>(from value: T) throws
    func setData<T: Encodable>(from value: T, merge: Bool) throws
    func setData<T: Encodable>(from value: T, merge: Bool, completion: ((Error?) -> Void)?) throws
    func updateData(fields: [AnyHashable: Any])
    func updateData(fields: [AnyHashable: Any], completion: ((Error?) -> Void)?)
    func delete()
    func delete(completion: ((Error?) -> Void)?)
}

public protocol CollectionReferenceWritable {
    func document() -> DocumentReferenceWritable
    func document(_ documentPath: String) -> DocumentReferenceWritable
}
