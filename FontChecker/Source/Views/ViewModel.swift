//
//  FontModel.swift
//  FontChecker
//
//  Created by 김효원 on 18/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ViewModel: ViewBindable {
    let disposeBag = DisposeBag()

    let fontViewModel: FontViewBindable
    let bgColorViewModel: BgColorViewBindable

    init() {
        self.fontViewModel = FontViewModel()
        self.bgColorViewModel = BgColorViewModel()
    }
}
