//
//  FontManager.swift
//  FontChecker
//
//  Created by 김효원 on 30/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift

protocol FontManager {
    func getFontList() -> [String]
    func loadCustomFont(filePath: String) -> Void
    func getCustomFonts() -> [String]?
    func setCustomFonts(fontURL: String) -> Void
}
