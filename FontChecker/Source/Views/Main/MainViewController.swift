//
//  MainViewController.swift
//  FontChecker
//
//  Created by 김효원 on 17/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import Then
import SnapKit

protocol MainViewBindable {
    var fontViewModel: FontViewBindable { get }
    var bgColorViewModel: ColorViewBindable { get }
    var textColorViewModel: ColorViewBindable { get }
    var sizeViewModel: SizeViewBindable { get }
    var attributes: PublishRelay<[NSAttributedString.Key: Any]> { get }
}

class MainViewController: ViewController<MainViewBindable> {
    let settingView = UIScrollView()
    let fontButton = FCButton()
    let bgColorButton = FCButton()
    let textColorButton = FCButton()
    let sizeButton = FCButton()
    let addFontButton = FCButton()
    let textView = UITextView()
    let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: nil)
    let cancleButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: nil)
    let fontView = FontView()
    let bgColorView = ColorView()
    let textColorView = ColorView()
    let sizeView = SizeView()

    var attributes = [NSAttributedString.Key: Any]()
    var tempAttributeText: NSAttributedString = NSAttributedString(string: "")

    override func bind(_ viewModel: MainViewBindable) {
        self.disposeBag = DisposeBag()

        self.rx.viewWillAppear
            .subscribe(onNext: { _ in
                self.fontView.bind(viewModel.fontViewModel)
                self.bgColorView.bind(viewModel.bgColorViewModel)
                self.textColorView.bind(viewModel.textColorViewModel)
                self.sizeView.bind(viewModel.sizeViewModel)
            })
            .disposed(by: disposeBag)

        viewModel.attributes
            .subscribe(onNext: {
                self.attributes.updateValue($0.values.first!, forKey: $0.keys.first!)
                self.textView.attributedText = NSMutableAttributedString(string: self.textView.text, attributes: self.attributes)
            })
            .disposed(by: disposeBag)

        bindUI()
    }

    func bindUI() {
        textView.rx.didChange
            .subscribe { _ in self.textView.attributedText = NSMutableAttributedString(string: self.textView.text, attributes: self.attributes) }
            .disposed(by: disposeBag)

        Observable.merge( doneButton.rx.tap.asObservable().map { return true }, cancleButton.rx.tap.asObservable().map { return false })
            .subscribe(onNext: {
                if !($0) { self.textView.attributedText = self.tempAttributeText }
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
                self.view.subviews.last?.removeFromSuperview()
            })
            .disposed(by: disposeBag)

        Observable.merge(
            fontButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.fontView, UIConstant.Setting.fontViewHeight) },
            bgColorButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.bgColorView, UIConstant.Setting.colorViewHeight) },
            textColorButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.textColorView, UIConstant.Setting.colorViewHeight) },
            sizeButton.rx.controlEvent(.touchUpInside).asObservable()
                .map { _ -> (UIView, CGFloat) in (self.sizeView, UIConstant.Setting.sizeViewHeight) })
            .subscribe(onNext: { (subview, height) in
                self.tempAttributeText = self.textView.attributedText
                self.navigationItem.leftBarButtonItem = self.doneButton
                self.navigationItem.rightBarButtonItem = self.cancleButton
                self.view.addSubview(subview)
                subview.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(self.fontButton.snp.bottom)
                    $0.height.equalTo(height)
                }
            })
            .disposed(by: disposeBag)
    }

    override func attribute() {
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Font Checker"

        textView.do {
            $0.backgroundColor = .white
            $0.font = UIConstant.Base.font
        }

        settingView.do {
            $0.backgroundColor = UIConstant.Setting.backgroundColor
            $0.showsHorizontalScrollIndicator = false
        }

        fontButton.setTitle("폰트 변경", for: .normal)
        bgColorButton.setTitle("BG색", for: .normal)
        textColorButton.setTitle("TEXT색", for: .normal)
        sizeButton.setTitle("TEXT크기", for: .normal)
        addFontButton.setTitle("폰트 추가", for: .normal)
    }

    override func layout() {
        view.addSubview(textView)
        settingView.addHorizentalSubviews([fontButton, bgColorButton, textColorButton, sizeButton, addFontButton], ratio: UIConstant.Setting.leftRatio, margin: UIConstant.Setting.leftMargin)
        settingView.contentSize = CGSize(width: view.frame.width + (UIConstant.Setting.leftMargin * CGFloat(settingView.subviews.count)), height: settingView.bounds.height)
        view.addSubview(settingView)

        settingView.snp.makeConstraints {
            $0.trailing.leading.bottom.equalToSuperview()
            $0.height.equalTo(UIConstant.Setting.height)
        }

        _ = [fontButton, bgColorButton, textColorButton, sizeButton, addFontButton].map {
            $0.snp.makeConstraints {
                $0.height.equalTo(UIConstant.Setting.buttonHeight)
                $0.top.equalToSuperview().inset(UIConstant.Setting.topMargin)
            }
        }

        let safeAreaInsetsTop = (UIApplication.shared.windows.first { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
        let height = (navigationController?.navigationBar.bounds.height ?? 0) + safeAreaInsetsTop
        textView.snp.makeConstraints {
            $0.top.equalTo(height)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(fontButton.snp.top)
        }
    }
}
