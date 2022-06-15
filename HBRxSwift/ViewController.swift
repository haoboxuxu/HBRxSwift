//
//  ViewController.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/6/15.
//

import UIKit

enum Event<Element> {
    case next(Element)
    case error(Error)
    case finished
}

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
    
    func subscribe<O: ObserverType>(observer: O) where O.Element == Element
}

class Observable<Element>: ObservableType {
    private let _eventGenerator: (Observer<Element>) -> Void
    
    init(_eventGenerator: @escaping (Observer<Element>) -> Void) {
        self._eventGenerator = _eventGenerator
    }
    
    func subscribe<O>(observer: O) where O : ObserverType, Element == O.Element {
        _eventGenerator(observer as! Observer<Element>)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observable = Observable<Int> { observer in
            observer.on(event: .next(1))
            observer.on(event: .next(2))
            observer.on(event: .next(3))
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
        
        observable.subscribe(observer: observer)
    }


}

