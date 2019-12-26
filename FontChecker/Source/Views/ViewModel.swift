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
    let bgColorViewModel: ColorViewBindable
    let textColorViewModel: ColorViewBindable

    var attributes = PublishRelay<[NSAttributedString.Key: Any]>()

    init() {
        self.fontViewModel = FontViewModel()
        self.bgColorViewModel = ColorViewModel()
        self.textColorViewModel = ColorViewModel()

        fontViewModel.fontData.asObservable()
            .map{ [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: $0)] }
            .bind(to: attributes)
            .disposed(by: disposeBag)

        bgColorViewModel.colorData.asObservable()
            .map{ [NSAttributedString.Key.backgroundColor: $0] }
            .bind(to: attributes)
            .disposed(by: disposeBag)

        textColorViewModel.colorData.asObservable()
            .map{ [NSAttributedString.Key.foregroundColor: $0] }
            .bind(to: attributes)
            .disposed(by: disposeBag)
    }
}
