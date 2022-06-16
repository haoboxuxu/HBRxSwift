//
//  Disposable.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/6/15.
//

import Foundation

protocol Disposable {
    func dispose()
}

class CompositeDisposable: Disposable {
    
    private(set) var isDisposed: Bool = false
    
    private var _disposables: [Disposable] = []
    
    init() { }
    
    func add(_ disposable: Disposable) {
        if isDisposed {
            disposable.dispose()
        }
        _disposables.append(disposable)
    }
    
    func dispose() {
        guard !isDisposed else {
            return
        }
        _disposables.forEach { $0.dispose() }
        isDisposed = true
    }
}

class AnonymousDisposable: Disposable {
    
    private let _disposableHandler: () -> Void
    
    init(_ disposableHandler: @escaping () -> Void) {
        self._disposableHandler = disposableHandler
    }
    
    func dispose() {
        _disposableHandler()
    }
}
