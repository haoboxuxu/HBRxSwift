//
//  rx.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/8/30.
//

import Foundation

enum Event<Element> {
    case next(Element)
    case error(Error)
    case finish
}


protocol PublisherType {
    associatedtype Element
    
    func pub(event: Event<Element>)
}

class Publisher<Element>: PublisherType {
    private let _handler: (Event<Element>) -> Void
    
    init(_ handler: @escaping (Event<Element>) -> Void) {
        _handler = handler
    }
    
    func pub(event: Event<Element>) {
        _handler(event)
    }
}

protocol SubscriberType {
    associatedtype Element
    
    func subscribe<P: PublisherType>(publisher: P) where P.Element == Element
}

class Subscriber<Element>: SubscriberType {
    
    private let _eventGenerator: (Publisher<Element>) -> Void
    
    init(_ eventGenerator: @escaping (Publisher<Element>) -> Void) {
        _eventGenerator = eventGenerator
    }
    
    func subscribe<P: PublisherType>(publisher: P) where P.Element == Element {
        _eventGenerator(publisher as! Publisher<Element>)
    }
}
