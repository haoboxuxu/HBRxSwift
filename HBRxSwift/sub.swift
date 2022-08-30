//
//  sub.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/8/30.
//

import Foundation

protocol SubscriberType {
    associatedtype Element
    
    func subscribe<P: PublisherType>(publisher: P) -> Disposable where P.Element == Element
}

class Subscriber<Element>: SubscriberType {
    
    private let _eventGenerator: (Publisher<Element>) -> Disposable
    
    init(_ eventGenerator: @escaping (Publisher<Element>) -> Disposable) {
        _eventGenerator = eventGenerator
    }
    
    func subscribe<P: PublisherType>(publisher: P) -> Disposable where P.Element == Element {
        let sink = Sink(forward: publisher, eventGenerator: _eventGenerator)
        sink.run()
        return sink
    }
}
