//
//  Enums.swift
//  FontChecker
//
//  Created by 김효원 on 30/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation

enum FTError: Error {
    case error(String)
    case defaultError

    var message: String? {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "네트워크 오류"
        }
    }
}
