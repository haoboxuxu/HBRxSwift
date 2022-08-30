//
//  ViewController.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/8/30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        runrx()
    }

    func runrx() {
        let subscriber = Subscriber<Int> { publisher -> Disposable in
            publisher.pub(event: .next(1))
            publisher.pub(event: .next(2))
            publisher.pub(event: .next(3))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                publisher.pub(event: .finish)
            }
            return AnonymouseDisposable {
                print("AnonymouseDisposable")
            }
        }
        
        let publisher = Publisher<Int> { (event) in
            switch event {
            case .next(let value):
                print("receive next \(value)")
            case .error(let error):
                print("receive error \(error)")
            case .finish:
                print("receive finish")
            }
        }
        
        let dispoable = subscriber.subscribe(publisher: publisher)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            dispoable.dispose()
        }
    }
}

