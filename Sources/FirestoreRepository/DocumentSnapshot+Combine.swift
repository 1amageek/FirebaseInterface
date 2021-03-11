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


extension DocumentSnapshot {

    final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == DocumentSnapshot, SubscriberType.Failure == Error {

        private var registration: ListenerRegistration?

        init(subscriber: SubscriberType, documentReference: DocumentReference, includeMetadataChanges: Bool) {
            registration = documentReference.addSnapshotListener (includeMetadataChanges: includeMetadataChanges) { [subscriber] (snapshot, error) in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else if let snapshot = snapshot {
                    _ = subscriber.receive(snapshot)
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
