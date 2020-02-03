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
        
        if let customFonts = getCustomFonts() {
            for name in customFonts {
                print("loadCustom Font \(name)")
                loadCustomFont(filePath: name)
            }
        }
        
        for name in UIFont.familyNames {
            fontNames.append(contentsOf: UIFont.fontNames(forFamilyName: name))
        }
        
        return fontNames
    }
    
    func loadCustomFont(filePath: String) {
        guard let fontData = NSData(contentsOfFile: filePath),
            let dataProvider = CGDataProvider.init(data: fontData),
            let cgFont = CGFont.init(dataProvider) else {
                print("폰트 파일 오류입니다. \(filePath)")
                return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            print("폰트 설치를 실패하였습니다.")
            return
        }
    }
    
    func setCustomFonts(fontURL: String) {
        var customFonts: [String] = UserDefaults.standard.value(forKey: "CustomFonts") as? [String] ?? []
        if !isAlreadyFont(fontURL) { customFonts.append(fontURL) }
        
        UserDefaults.standard.set(customFonts, forKey: "CustomFonts")
    }
    
    func getCustomFonts() -> [String]? {
        return UserDefaults.standard.value(forKey: "CustomFonts") as? [String]
    }
    
    func isAlreadyFont(_ fontURL: String) -> Bool {
        let customFonts: [String] = UserDefaults.standard.value(forKey: "CustomFonts") as? [String] ?? []
        return customFonts.contains(fontURL)
    }
}
   
//http://pop.baemin.com/fonts/yeonsung/BMYEONSUNG_otf.otf
//http://pop.baemin.com/fonts/jua/BMJUA_otf.otf
