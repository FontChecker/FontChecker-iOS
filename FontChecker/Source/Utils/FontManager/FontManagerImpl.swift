//
//  FontManagerImpl.swift
//  FontChecker
//
//  Created by 김효원 on 27/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FontManagerImpl: FontManager {
    static let shared = FontManagerImpl()

    func getFontList() -> [String]{
        var fontNames = [String]()
        for name in UIFont.familyNames {
            fontNames.append(contentsOf: UIFont.fontNames(forFamilyName: name))
        }
        return fontNames
    }

    func installFont(filePath: String) -> Observable<Result<String, FTError>> {
        guard let fontData = NSData(contentsOfFile: filePath)
            ,let dataProvider = CGDataProvider.init(data: fontData)
            ,let cgFont = CGFont.init(dataProvider) else {
                let err = FTError.error("폰트 파일 오류입니다.")
                return .just(.failure(err))
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            let err = FTError.error("폰트 설치를 실패하였습니다.")
            return .just(.failure(err))
        }

        guard let fontName = cgFont.postScriptName else {
            let err = FTError.error("폰트 파일을 찾을 수 없습니다.")
            return .just(.failure(err))
        }

        return .just(.success(String(fontName)))
    }
}
