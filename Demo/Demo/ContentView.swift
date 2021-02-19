//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/02/18.
//

import SwiftUI
import FirestoreProtocol
import Combine
import FirebaseFirestore

//public struct DocumentRepository<T> {
//
//    public typealias Publisher = AnyPublisher<T?, Error>
//
//    public var publisher: Publisher
//
//    public init<Reference: DocumentPublishable>(_ reference: Reference, content: (Reference) -> Publisher) {
//        self.publisher = content(reference)
//    }
//}



//public struct Document {
//
//    public typealias Reference = DocumentPublishable
//
//    public var reference: Reference
//
//    public var source: Source
//
//    public static func get<T: Decodable>(reference: Reference, source: Source) -> AnyPublisher<T?, Error> {
//        return reference.get(source: source)
//    }
//
//}
//
//@propertyWrapper public struct DocumentRepository<T> {
//
//    public typealias Publisher = AnyPublisher<T?, Error>
//
//    public var wrappedValue: Request
//
//    public var projectedValue: Publisher
//
////    public init(_ reference: Reference, content: (Reference) -> Publisher) {
////        self.wrappedValue = reference
////        self.projectedValue = content(reference)
////    }
//
//    public init(_ request: Request) {
//        self.wrappedValue = request
//        self.projectedValue = request.reference.get(source: request.source)
//    }
//}

class Interactor: ObservableObject {

    typealias Reference = DocumentPublishable

    var cancelables: [AnyCancellable] = []

    var user: AnyPublisher<User?, Error>

    init(user: AnyPublisher<User?, Error>) {
        self.user = user
    }

//    @DocumentRepository<User> var reference: Reference
//
//    init(reference: Reference) {
//        self._reference = DocumentRepository(reference)
//    }
}

struct User: Codable { }

struct Item: Codable { }

struct ContentView: View {

    @EnvironmentObject var interactor: Interactor

    @State var data: [User] = []

    @State var user: User?

    var body: some View {

        Button(action: {

//            self.interactor.repository.doc

        }, label: {
            Text("Hello, world!")
                .padding()
        })
        .onAppear {

            interactor.user.sink { _ in

            } receiveValue: { user in
                self.user = user
            }

//            interactor.$repository.sink { _ in
//
//            } receiveValue: { user in
//                self.user = user
//            }


//            interactor.repository.publisher.sink { _ in
//
//            } receiveValue: { user in
//                self.user = user
//            }.store(in: &self.interactor.cancelables)

//            interactor.documentRef.get(source: .default)

//            interactor.collectionRef.get(source: .cache).sink { collection in
//                self.data = collection
//            }

//            interactor.repository.usersPublisher.sink { error in
//
//            } receiveValue: { users in
            //                self.data = users ?? []
            //            }.store(in: &interactor.cancelables)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(
                Interactor(user: Firestore.firestore().document("").get(source: .default))
            )
//            .environmentObject(
//                Interactor(
//                    repository: DocumentRepository(Firestore.firestore().document("")) { $0.get() }
//                ))
    }
}
