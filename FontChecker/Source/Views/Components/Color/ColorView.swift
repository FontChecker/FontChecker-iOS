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
            blueSlider.rx.controlEvent(.valueChanged).asObservable()
        )
            .map { _ -> UIColor in
                self.redTextField.text = "\(self.redSlider.value)"
                self.greenTextField.text = "\(self.greenSlider.value)"
                self.blueTextField.text = "\(self.blueSlider.value)"
                return UIColor(displayP3Red: CGFloat(self.redSlider.value/255), green: CGFloat(self.greenSlider.value/255), blue: CGFloat(self.blueSlider.value/255), alpha: 1)
            }

        let textValueChange = Observable.merge(
            redTextField.rx.controlEvent(.editingDidEnd).asObservable(),
            greenTextField.rx.controlEvent(.editingDidEnd).asObservable(),
            blueTextField.rx.controlEvent(.editingDidEnd).asObservable()
        )
            .map { _ -> [Float]? in
                guard let red = Float(self.redTextField.text ?? "0"),
                    let green = Float(self.greenTextField.text ?? "0"),
                    let blue = Float(self.blueTextField.text ?? "0")
                    else { return nil }
                return [red, green, blue]
            }
            .filterNil()
            .map { color -> UIColor in
                self.redSlider.value = color[0]
                self.greenSlider.value = color[1]
                self.blueSlider.value = color[2]
                return UIColor(displayP3Red: CGFloat(color[0]/255), green: CGFloat(color[1]/255), blue: CGFloat(color[2]/255), alpha: 1)
            }

        Observable.merge(sliderValueChange, textValueChange)
            .bind(to: viewModel.colorData)
            .disposed(by: disposeBag)
    }

    override func attribute() {
        self.backgroundColor = .white

        _ = [redSlider, greenSlider, blueSlider].map {
            $0.minimumValue = 0
            $0.maximumValue = 255
            $0.value = 127.5
            $0.maximumTrackTintColor = .lightGray
        }
        redSlider.minimumTrackTintColor = .systemRed
        greenSlider.minimumTrackTintColor = .systemGreen
        blueSlider.minimumTrackTintColor = .systemBlue

        _ = [redTextField, greenTextField, blueTextField].map {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            $0.layer.cornerRadius = 10
            $0.textColor = .white
            $0.textAlignment = .center
            $0.keyboardType = .numberPad
        }

        redTextField.do {
            $0.text = "\(self.redSlider.value)"
            $0.backgroundColor = .systemRed
        }

        greenTextField.do {
            $0.text = "\(self.greenSlider.value)"
            $0.backgroundColor = .systemGreen
        }

        blueTextField.do {
            $0.text = "\(self.blueSlider.value)"
            $0.backgroundColor = .systemBlue
        }
    }

    override func layout() {
        let colorTextView = UIView()
        colorTextView.addHorizentalSubviews([redTextField, greenTextField, blueTextField], ratio: 0.5, margin: 15)

        self.addVerticalSubviews([blueSlider, greenSlider, redSlider, colorTextView], margin: 15)
    }
}
