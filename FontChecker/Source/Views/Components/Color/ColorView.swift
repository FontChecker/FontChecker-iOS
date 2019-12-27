//
//  ColorView.swift
//  FontChecker
//
//  Created by 김효원 on 20/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

protocol ColorViewBindable {
    var colorData: PublishRelay<UIColor> { get }
}

class ColorView: SettingView<ColorViewBindable> {
    let redSlider = UISlider()
    let greenSlider = UISlider()
    let blueSlider = UISlider()
    let redTextField = UITextField()
    let greenTextField = UITextField()
    let blueTextField = UITextField()

    override func bind(_ viewModel: ColorViewBindable) {
        self.disposeBag = DisposeBag()

        let sliderValueChange = Observable.merge(
            redSlider.rx.controlEvent(.valueChanged).asObservable(),
            greenSlider.rx.controlEvent(.valueChanged).asObservable(),
            blueSlider.rx.controlEvent(.valueChanged).asObservable())
            .map { _ -> UIColor in
                self.redTextField.text = "\(self.redSlider.value)"
                self.greenTextField.text = "\(self.greenSlider.value)"
                self.blueTextField.text = "\(self.blueSlider.value)"
                return UIColor(displayP3Red: CGFloat(self.redSlider.value/255), green: CGFloat(self.greenSlider.value/255), blue: CGFloat(self.blueSlider.value/255), alpha: 1)
        }

        let textValueChange = Observable.merge(
            redTextField.rx.controlEvent(.editingDidEnd).asObservable(),
            greenTextField.rx.controlEvent(.editingDidEnd).asObservable(),
            blueTextField.rx.controlEvent(.editingDidEnd).asObservable())
            .map { _ -> UIColor? in
                guard let red = Float(self.redTextField.text ?? "0"), let green = Float(self.greenTextField.text ?? "0"), let blue = Float(self.blueTextField.text ?? "0") else { return nil }
                self.redSlider.value = red
                self.greenSlider.value = green
                self.blueSlider.value = blue
                return UIColor(displayP3Red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        }
        .filterNil()

        Observable.merge(sliderValueChange, textValueChange)
            .bind(to: viewModel.colorData)
            .disposed(by: disposeBag)
    }

    override func attribute() {
        self.backgroundColor = UIConstant.Setting.backgroundColor

        _ = [redSlider, greenSlider, blueSlider].map {
            $0.minimumValue = 0
            $0.maximumValue = 255
            $0.value = 127.5
            $0.maximumTrackTintColor = .white
        }
        redSlider.minimumTrackTintColor = UIConstant.Color.red
        greenSlider.minimumTrackTintColor = UIConstant.Color.green
        blueSlider.minimumTrackTintColor = UIConstant.Color.blue

        _ = [redTextField, greenTextField, blueTextField].map {
            $0.font = UIFont.systemFont(ofSize: UIConstant.Base.fontSize, weight: .bold)
            $0.layer.cornerRadius = UIConstant.Setting.textFieldRadius
            $0.textColor = .white
            $0.textAlignment = .center
            $0.keyboardType = .numberPad
        }

        redTextField.do {
            $0.text = "\(self.redSlider.value)"
            $0.backgroundColor = UIConstant.Color.red
        }

        greenTextField.do {
            $0.text = "\(self.greenSlider.value)"
            $0.backgroundColor = UIConstant.Color.green
        }

        blueTextField.do {
            $0.text = "\(self.blueSlider.value)"
            $0.backgroundColor = UIConstant.Color.blue
        }
    }

    override func layout() {
        let colorTextView = UIView()
        colorTextView.addHorizentalSubviews([redTextField, greenTextField, blueTextField], ratio: UIConstant.Setting.leftRatio, margin: UIConstant.Setting.leftMargin)

        self.addVerticalSubviews([blueSlider, greenSlider, redSlider, colorTextView], margin: UIConstant.Setting.bottomMargin)
        colorTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIConstant.Setting.topMargin)
        }
    }
}
