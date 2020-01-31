//
//  Constants.swift
//  FontChecker
//
//  Created by 김효원 on 19/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import UIKit

public struct Constant {
    struct UI {
        struct Base {
            static let font: UIFont = UIFont.systemFont(ofSize: fontSize)
            static let fontSize: CGFloat = 15
            static let backgroundColor: UIColor = .white
        }
        
        struct Setting {
            static let backgroundColor: UIColor = UIColor(displayP3Red: (231/255), green: (232/255), blue: (233/255), alpha: 1.0)
            static let fontColor: UIColor = .black
            static let height: CGFloat = buttonHeight + 50
            static let leftMargin: CGFloat = 15
            static let leftRatio: CGFloat = 0.5
            static let bottomMargin: CGFloat = 15
            static let bottomRatio: CGFloat = 0.5
            static let topMargin: CGFloat = 10
            static let fontViewHeight: CGFloat = 180
            static let colorViewHeight: CGFloat = 180
            static let sizeViewHeight: CGFloat = 130
            static let textFieldRadius: CGFloat = 10
            static let buttonRadius: CGFloat = 15
            static let buttonHeight: CGFloat = 60
        }

        struct Color {
            static let red: UIColor = UIColor(displayP3Red: (238/255), green: (64/255), blue: (65/255), alpha: 1)
            static let green: UIColor = UIColor(displayP3Red: (48/255), green: (191/255), blue: (71/255), alpha: 1)
            static let blue: UIColor = UIColor(displayP3Red: (11/255), green: (95/255), blue: (254/255), alpha: 1)
        }
    }
}

public struct FileConstant {
    struct Path {
        static let baseDirName = "FontChecker"
    }
}
