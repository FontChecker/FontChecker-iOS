//
//  BgColorView.swift
//  FontChecker
//
//  Created by 김효원 on 20/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BgColorViewBindable {
    var bgColorData: PublishRelay<UIColor> { get }
}

class BgColorView: SettingView<BgColorViewBindable> {

    override func bind(_ viewModel: BgColorViewBindable) {
        self.disposeBag = DisposeBag()
    }

    override func attribute() {
        self.backgroundColor = .white
    }

    override func layout() {
    }
}
