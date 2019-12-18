//
//  ViewController.swift
//  FontChecker
//
//  Created by 김효원 on 17/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
    let fontButton = UIButton()
    let bgColorButton = UIButton()
    let textColorButton = UIButton()
    let sizeButton = UIButton()
    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    func attribute() {
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Font Checker"

        fontButton.do {
            $0.setTitle("폰트변경", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        bgColorButton.do {
            $0.setTitle("BG색", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        textColorButton.do {
            $0.setTitle("TEXT색", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        sizeButton.do {
            $0.setTitle("TEXT크기", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.gray.cgColor
        }

        textView.do {
            $0.backgroundColor = .white
            $0.isEditable = true
        }
    }

    func layout() {
        view.addSubview(fontButton)
        view.addSubview(bgColorButton)
        view.addSubview(textColorButton)
        view.addSubview(sizeButton)
        view.addSubview(textView)

        fontButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.equalToSuperview()
        }

        bgColorButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.equalTo(fontButton.snp.trailing)
            $0.trailing.equalTo(textColorButton.snp.leading)
        }

        textColorButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.equalTo(bgColorButton.snp.trailing)
            $0.trailing.equalTo(sizeButton.snp.leading)
        }

        sizeButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview().dividedBy(4)
            $0.bottom.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview()
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
