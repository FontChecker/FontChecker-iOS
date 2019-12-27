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
            $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstant.Base.fontSize)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = UIConstant.Setting.buttonRadius
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
