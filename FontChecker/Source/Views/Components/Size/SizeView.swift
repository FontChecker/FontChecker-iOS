//
//  SizeView.swift
//  FontChecker
//
//  Created by 김효원 on 26/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

protocol SizeViewBindable {
    var sizeData: PublishRelay<CGFloat> { get }
}

class SizeView: SettingView<SizeViewBindable> {
    let sizeSlider = UISlider()
    let sizeTextField = UITextField()
    
    private typealias UI = Constant.UI.Size

    override func bind(_ viewModel: SizeViewBindable) {
        let sliderValueChange = sizeSlider.rx.controlEvent(.valueChanged).asObservable()
            .map { _ -> CGFloat in
                self.sizeTextField.text = "\(self.sizeSlider.value)"
                return CGFloat(self.sizeSlider.value)
            }

        let textValueChange = sizeTextField.rx.controlEvent(.editingDidEnd).asObservable()
            .map { _ -> CGFloat? in
                guard let size = Float(self.sizeTextField.text ?? "0") else { return nil }
                self.sizeSlider.value = size
                return CGFloat(size)
        }
        .filterNil()

        Observable.merge(sliderValueChange, textValueChange)
            .bind(to: viewModel.sizeData)
            .disposed(by: disposeBag)
    }

    override func attribute() {
        self.backgroundColor = UI.backgroundColor

        sizeSlider.do {
            $0.minimumValue = 0
            $0.maximumValue = 100
            $0.value = Float(0)
            $0.maximumTrackTintColor = .white
        }

        sizeTextField.do {
            $0.font = UIFont.systemFont(ofSize: Constant.UI.Base.fontSize, weight: .bold)
            $0.layer.cornerRadius = UI.textFieldRadius
            $0.textColor = .white
            $0.textAlignment = .center
            $0.keyboardType = .numberPad
            $0.text = "\(self.sizeSlider.value)"
            $0.backgroundColor = UIColor(displayP3Red: (11/255), green: (95/255), blue: (254/255), alpha: 1)
        }
    }

    override func layout() {
        self.addVerticalSubviews([sizeSlider, sizeTextField], ratio: UI.bottomRatio, margin: UI.bottomMargin)

        sizeTextField.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(4)
        }
    }
}
