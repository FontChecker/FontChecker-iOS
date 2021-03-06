//
//  UIView+Layout.swift
//  FontChecker
//
//  Created by 김효원 on 19/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import UIKit

extension UIView {
    func addHorizentalSubviews(_ subviews: [UIView], ratio: CGFloat = 0.0, margin: CGFloat = 0.0) {
        _ = subviews.map { self.addSubview($0) }

        guard let first = subviews.first else { return }
        first.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(CGFloat(subviews.count) + ratio)
            $0.leading.equalToSuperview().inset(margin)
        }

        for index in 1..<subviews.count {
            subviews[index].snp.makeConstraints {
                $0.width.equalToSuperview().dividedBy(CGFloat(subviews.count) + ratio)
                $0.leading.equalTo(subviews[index-1].snp.trailing).offset(margin)
            }
        }
        
        guard let last = subviews.last else { return }
        last.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(margin)
        }
    }

    func addVerticalSubviews(_ subviews: [UIView], ratio: CGFloat = 0.0, margin: CGFloat = 0.0) {
        _ = subviews.map { self.addSubview($0) }

        guard let first = subviews.first else { return }
        first.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(margin)
            $0.height.equalToSuperview().dividedBy(CGFloat(subviews.count) + ratio)
            $0.bottom.equalToSuperview()
        }

        for index in 1..<subviews.count {
            subviews[index].snp.makeConstraints {
                $0.trailing.leading.equalToSuperview().inset(margin)
                $0.height.equalToSuperview().dividedBy(CGFloat(subviews.count) + ratio)
                $0.bottom.equalTo(subviews[index-1].snp.top)
            }
        }
    }
}
