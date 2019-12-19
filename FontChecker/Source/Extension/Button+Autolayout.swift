//
//  Button+Autolayout.swift
//  FontChecker
//
//  Created by 김효원 on 19/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setFCButton(title: String){
        self.do {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 60
            $0.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
