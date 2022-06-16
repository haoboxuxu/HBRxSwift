//
//  ViewController.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/6/15.
//

import UIKit

protocol SubscriberType {
    associatedtype Element

    func sub(event: Event<Element>)
}

class Subscriber<Element>: SubscriberType {
    private let _handler: (Event<Element>) -> Void
    
    init(_handler: @escaping (Event<Element>) -> Void) {
        self._handler = _handler
    }
    
    func sub(event: Event<Element>) {
        _handler(event)
    }
}

protocol PublishableType {
    associatedtype Element
    
    func pub<S: SubscriberType>(subscriber: S) -> Disposable where S.Element == Element
}

class Publisher<Element>: PublishableType {
    
    private let _eventGenerator: (Subscriber<Element>) -> Disposable
    
    init(_eventGenerator: @escaping (Subscriber<Element>) -> Disposable) {
        self._eventGenerator = _eventGenerator
    }
    
    func pub<S: SubscriberType>(subscriber: S) -> Disposable where S.Element == Element {
        let compositeDisposable = CompositeDisposable()
        let disposable = _eventGenerator(Subscriber { event in
            guard !compositeDisposable.isDisposed else {
                return
            }
            subscriber.sub(event: event)
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
        
        let publisher = Publisher<Int> { subscriber -> Disposable in
            subscriber.sub(event: .next(1))
            subscriber.sub(event: .next(2))
            subscriber.sub(event: .next(3))
            subscriber.sub(event: .next(4))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                subscriber.sub(event: .finished)
            }
            
            return AnonymousDisposable {
                print("Anonymous Dispose")
            }
        }
        
        let subscriber = Subscriber<Int> { event in
            switch event {
            case .next(let value):
                print("next(\(value))")
            case .error(let error):
                print("next(\(error))")
            case .finished:
                print("finished")
            }
        }
        
        let disposable = publisher.pub(subscriber: subscriber)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            disposable.dispose()
        }
    }
}

