//
//  QuerySnapshot+Combine.swift
//  
//
//  Created by nori on 2021/03/11.
//

import Foundation
import Combine
import FirestoreProtocol
import FirebaseFirestore


extension QuerySnapshot {
    
    final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == QuerySnapshot, SubscriberType.Failure == Error {

        private var registration: ListenerRegistration?

        init(subscriber: SubscriberType, query: Query, includeMetadataChanges: Bool) {
            registration = query.addSnapshotListener (includeMetadataChanges: includeMetadataChanges) { [subscriber] (querySnapshot, error) in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else if let querySnapshot = querySnapshot {
                    _ = subscriber.receive(querySnapshot)
                } else {
                    subscriber.receive(completion: .failure(FirestoreError.nilResultError))
                }
            }
        }

        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            registration?.remove()
            registration = nil
        }
    }
}
