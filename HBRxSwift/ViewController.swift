//
//  ViewController.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/6/15.
//

import UIKit

protocol ObserverType {
    associatedtype Element

    func on(event: Event<Element>)
}

class Observer<Element>: ObserverType {
    private let _handler: (Event<Element>) -> Void
    
    init(_handler: @escaping (Event<Element>) -> Void) {
        self._handler = _handler
    }
    
    func on(event: Event<Element>) {
        _handler(event)
    }
}

protocol ObservableType {
    associatedtype Element
    
    func subscribe<O: ObserverType>(observer: O) -> Disposable where O.Element == Element
}

class Observable<Element>: ObservableType {
    
    private let _eventGenerator: (Observer<Element>) -> Disposable
    
    init(_eventGenerator: @escaping (Observer<Element>) -> Disposable) {
        self._eventGenerator = _eventGenerator
    }
    
    func subscribe<O: ObserverType>(observer: O) -> Disposable where O.Element == Element {
        let compositeDisposable = CompositeDisposable()
        let disposable = _eventGenerator(Observer { event in
            guard !compositeDisposable.isDisposed else {
                return
            }
            observer.on(event: event)
            switch event {
            case .error, .finished:
                compositeDisposable.dispose()
            default:
                break
            }
        })
        compositeDisposable.add(disposable)
        return disposable
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observable = Observable<Int> { observer -> Disposable in
            observer.on(event: .next(1))
            observer.on(event: .next(2))
            observer.on(event: .next(3))
            observer.on(event: .next(4))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                observer.on(event: .finished)
            }
            
            return AnonymousDisposable {
                print("Anonymous Dispose")
            }
        }
        
        let observer = Observer<Int> { event in
            switch event {
            case .next(let value):
                print("next(\(value))")
            case .error(let error):
                print("next(\(error))")
            case .finished:
                print("finished")
            }
        }
        
        let disposable = observable.subscribe(observer: observer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            disposable.dispose()
        }
    }
}

