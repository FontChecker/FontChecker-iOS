//
//  View.swift
//  FontChecker
//
//  Created by 김효원 on 20/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingView<Bindable>: UIView {
    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: Bindable) { }

    func attribute() { }

    func layout() { }
}
