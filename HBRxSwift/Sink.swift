//
//  Sink.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/6/16.
//

import Foundation

class Sink<S: SubscriberType>: Disposable {
    
    private var _disposed: Bool = false
    private let _forward: S
    private let _eventGenerator: (Subscriber<S.Element>) -> Disposable
    private let _compositeDisposable = CompositeDisposable()
    
    init(forward: S, eventGenerator: @escaping (Subscriber<S.Element>) -> Disposable) {
        self._forward = forward
        self._eventGenerator = eventGenerator
    }
    
    func run() {
        let subscriber = Subscriber<S.Element>(forward)
        _compositeDisposable.add(_eventGenerator(subscriber))
    }
    
    private func forward(event: Event<S.Element>) {
        guard !_disposed else {
            return
        }
        _forward.sub(event: event)
        switch event {
        case .finished, .error(_):
            dispose()
        default:
            break
        }
    }
    
    func dispose() {
        _disposed = true
        _compositeDisposable.dispose()
    }
}
