//
//  BgColorViewModel.swift
//  FontChecker
//
//  Created by 김효원 on 23/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ColorViewModel: ColorViewBindable {
    let disposeBag = DisposeBag()

    let colorData = PublishRelay<UIColor>()

    init() { }
}
