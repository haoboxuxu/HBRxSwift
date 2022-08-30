//
//  dispose.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/8/30.
//

import Foundation

protocol Disposable {
    func dispose()
}

final class AnonymouseDisposable: Disposable {
    
    private let _disposeHandler: () -> Void
    
    init(_ disposeHandler: @escaping () -> Void) {
        _disposeHandler = disposeHandler
    }
    
    func dispose() {
        _disposeHandler()
    }
}

class CompositeDisposable: Disposable {
    
    private(set) var isDisposed: Bool = false
    
    private var disposables: [Disposable] = []
    
    init() {}
    
    func add(disposable: Disposable) {
        if isDisposed {
            disposable.dispose()
            return
        }
        disposables.append(disposable)
    }
    
    func dispose() {
        guard !isDisposed else { return }
        disposables.forEach { disposable in
            disposable.dispose()
        }
        isDisposed = true
    }
}
