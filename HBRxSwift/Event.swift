//
//  Event.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/6/15.
//

import Foundation

enum Event<Element> {
    case next(Element)
    case error(Error)
    case finished
}
