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
    var fontData: PublishRelay<String> { get }
    var reloadFonts: PublishRelay<[String]> { get }
}

class FontView: SettingView<FontViewBindable> {
    let fontTable = UITableView()

    override func bind(_ viewModel: FontViewBindable) {
        self.disposeBag = DisposeBag()

        viewModel.reloadFonts
            .bind(to: fontTable.rx.items) { (_, _, title) -> UITableViewCell in
                let cell = UITableViewCell()
                cell.textLabel?.text = title
                cell.backgroundColor = Constant.UI.Setting.backgroundColor
                cell.textLabel?.textColor = Constant.UI.Setting.fontColor
                return cell
            }
            .disposed(by: disposeBag)

        fontTable.rx.itemSelected
            .map { indexPath -> String? in
                guard let cell = self.fontTable.cellForRow(at: indexPath) else { return nil }
                _ = self.fontTable.visibleCells.map { $0.accessoryType = .none }
                cell.accessoryType = .checkmark
                return cell.textLabel?.text
            }
            .filterNil()
            .bind(to: viewModel.fontData)
            .disposed(by: disposeBag)
    }

    override func attribute() {
        self.backgroundColor = Constant.UI.Setting.backgroundColor
        fontTable.backgroundColor = Constant.UI.Setting.backgroundColor
    }

    override func layout() {
        self.addSubview(fontTable)

        fontTable.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
