//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/02/18.
//

import SwiftUI
import FirestoreProtocol
import Combine

class Repository {

    var usersPublisher: AnyPublisher<[User]?, Error> { doc.get(source: .cache) }

    var doc: DocumentReferencePublishable

    init(doc: DocumentReferencePublishable) {
        self.doc = doc
    }
}

class Interactor: ObservableObject {

    var repository: Repository

    var cancelables: [AnyCancellable] = []

    init(repository: Repository) {
        self.repository = repository
    }
}

struct User: Codable {

}

struct ContentView: View {

    @EnvironmentObject var interactor: Interactor

    @State var data: [User] = []

    var body: some View {

        Button(action: {


        }, label: {
            Text("Hello, world!")
                .padding()
        })
        .onAppear {
            interactor.repository.usersPublisher.sink { error in

            } receiveValue: { users in
                self.data = users ?? []
            }.store(in: &interactor.cancelables)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
