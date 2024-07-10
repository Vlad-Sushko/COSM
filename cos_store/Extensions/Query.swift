//
//  Query.swift
//  cos_store
//
//  Created by Vlad Sushko on 28/05/2024.
//

import Foundation
import FirebaseFirestore
import Combine

extension Query {
    
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        try await getDocumentsWithSnapshot(as: type).collection
    }
    
    func getDocumentsWithSnapshot<T: Decodable>(as type: T.Type) async throws -> (collection: [T], lastDocument: DocumentSnapshot?) {
        let snapshot = try await self.getDocuments()

        let collection = try snapshot.documents.map { document in
            return try document.data(as: T.self)
        }
        return (collection, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T:Decodable>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error Add Listener")
                return
            }
            
            let products: [T] = documents.compactMap( { try? $0.data(as: T.self)} )
            publisher.send(products)
        }
        return (publisher.eraseToAnyPublisher(), listener)
    }
}
    
