//
//  FCButton.swift
//  FontChecker
//
//  Created by 김효원 on 19/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit

class FCButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.do {
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
