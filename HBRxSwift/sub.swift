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
        let compositeDisposable = CompositeDisposable()
        let disposable = _eventGenerator(Publisher { event in
            guard !compositeDisposable.isDisposed else { return }
            publisher.pub(event: event)
            switch event {
            case .error(_), .finish:
                compositeDisposable.dispose()
            default:
                break
            }
        })
        compositeDisposable.add(disposable: disposable)
        return compositeDisposable
    }
}
