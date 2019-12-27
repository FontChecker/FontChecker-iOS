//
//  MainViewModel.swift
//  FontChecker
//
//  Created by 김효원 on 18/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel: MainViewBindable {
    let disposeBag = DisposeBag()

    let fontViewModel: FontViewBindable
    let bgColorViewModel: ColorViewBindable
    let textColorViewModel: ColorViewBindable
    let sizeViewModel: SizeViewBindable

    var attributes = PublishRelay<[NSAttributedString.Key: Any]>()

    init() {
        self.fontViewModel = FontViewModel()
        self.bgColorViewModel = ColorViewModel()
        self.textColorViewModel = ColorViewModel()
        self.sizeViewModel = SizeViewModel()

        let fontChange = Observable.combineLatest(
            fontViewModel.fontData.asObservable().startWith(UIConstant.Base.fontWeight),
            sizeViewModel.sizeData.asObservable().startWith(UIConstant.Base.fontSize))
            .map { (weight, size) -> [NSAttributedString.Key: Any] in
                return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: weight)]
            }

        Observable.merge(
            fontChange,
            bgColorViewModel.colorData.asObservable().map{ [NSAttributedString.Key.backgroundColor: $0] },
            textColorViewModel.colorData.asObservable().map{ [NSAttributedString.Key.foregroundColor: $0] })
            .bind(to: attributes)
            .disposed(by: disposeBag)
    }
}
