//
//  Constants.swift
//  FontChecker
//
//  Created by 김효원 on 19/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import UIKit

public struct UIConstant {
    struct Base {
        static let fontSize: CGFloat = 15
        static let backgroundColor: UIColor = .white
        static let fontWeight: UIFont.Weight = .regular
    }

    // Setting View, Setting View를 상속받는 View의 constant
    struct Setting {
        static let backgroundColor: UIColor = .lightGray
        static let height: CGFloat = fontViewHeight + 50
        static let leftMargin: CGFloat = 15
        static let leftRatio: CGFloat = 0.5
        static let bottomMargin: CGFloat = 15
        static let bottomRatio: CGFloat = 0.5
        static let topMargin: CGFloat = 10
        static let fontViewHeight: CGFloat = 60
        static let colorViewHeight: CGFloat = 180
        static let sizeViewHeight: CGFloat = 130
        static let textFieldRadius: CGFloat = 10
        static let buttonRadius: CGFloat = 15
    }

    struct Color {
        static let red: UIColor = UIColor(displayP3Red: (238/255), green: (64/255), blue: (65/255), alpha: 1)
        static let green: UIColor = UIColor(displayP3Red: (48/255), green: (191/255), blue: (71/255), alpha: 1)
        static let blue: UIColor = UIColor(displayP3Red: (11/255), green: (95/255), blue: (254/255), alpha: 1)
    }
}
