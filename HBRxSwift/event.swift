//
//  event.swift
//  HBRxSwift
//
//  Created by 徐浩博 on 2022/8/30.
//

import Foundation

enum Event<Element> {
    case next(Element)
    case error(Error)
    case finish
}
