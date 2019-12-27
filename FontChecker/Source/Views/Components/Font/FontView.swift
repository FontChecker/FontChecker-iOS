//
//  FontView.swift
//  FontChecker
//
//  Created by 김효원 on 18/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol FontViewBindable {
    var fontData: PublishRelay<UIFont.Weight> { get }
}

class FontView: SettingView<FontViewBindable> {
    let lightButton = FCButton()
    let regularButton = FCButton()
    let boldButton = FCButton()

    override func bind(_ viewModel: FontViewBindable) {
        self.disposeBag = DisposeBag()

        Observable.merge(
            lightButton.rx.controlEvent(.touchUpInside).asObservable()
                .map{ UIFont.Weight.light },
            regularButton.rx.controlEvent(.touchUpInside).asObservable()
                .map{ UIFont.Weight.regular },
            boldButton.rx.controlEvent(.touchUpInside).asObservable()
                .map{ UIFont.Weight.bold }
        )
        .bind(to: viewModel.fontData)
        .disposed(by: disposeBag)
    }

    override func attribute() {
        self.backgroundColor = UIConstant.Setting.backgroundColor

        lightButton.setTitle("light", for: .normal)
        regularButton.setTitle("regular", for: .normal)
        boldButton.setTitle("bold", for: .normal)
    }

    override func layout() {
        self.addHorizentalSubviews([lightButton, regularButton, boldButton], ratio: UIConstant.Setting.leftRatio, margin: UIConstant.Setting.leftMargin)

        _ = [lightButton, regularButton, boldButton].map {
            $0.snp.makeConstraints {
                $0.top.bottom.height.equalToSuperview()
            }
        }
    }
}
