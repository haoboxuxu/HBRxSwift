//
//  sink.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/8/30.
//

import Foundation

class Sink<P: PublisherType>: Disposable {
    
    private var _disposed: Bool = false
    private let _forward: P
    private let _eventGenerator: (Publisher<P.Element>) -> Disposable
    private let _compositeDisposable = CompositeDisposable()
    
    init(forward: P, eventGenerator: @escaping (Publisher<P.Element>) -> Disposable) {
        _forward = forward
        _eventGenerator = eventGenerator
    }
    
    func run() {
        let publisher = Publisher<P.Element>(forward)
        _compositeDisposable.add(disposable: _eventGenerator(publisher))
    }
    
    private func forward(event: Event<P.Element>) {
        guard !_disposed else { return }
        _forward.pub(event: event)
        switch event {
        case .error(_), .finish:
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
