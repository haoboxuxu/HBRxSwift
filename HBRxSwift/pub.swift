//
//  pub.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/8/30.
//

import Foundation

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
