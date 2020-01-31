//
//  DownloaderImpl.swift
//  FontChecker
//
//  Created by 김효원 on 30/12/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DownloaderImpl: Downloader {
    private let fileManager: FileManager
    private let session: URLSession

    init(session: URLSession = .shared, fileManager: FileManager = .default) {
        self.session = session
        self.fileManager = fileManager
    }

    func createDirectory(dirName: String = Constant.File.Path.baseDirName) -> String? {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent(dirName)
        if fileManager.fileExists(atPath: directoryURL.path) { return directoryURL.path }

        do {
            try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
            return directoryURL.path
        } catch {
            NSLog("Directory 생성 실패")
            return nil
        }
    }

    func downloadFile(url: String) -> Observable<Result<String, FTError>> {
        guard let urlComp = URLComponents(string: url)?.url else {
            let error = FTError.error("유효하지 않은 URL입니다.")
            return .just(.failure(error))
        }
        
        guard let folderPath = createDirectory(),
            let fileName = url.split(separator: "/").last else {
            let error = FTError.error("파일 생성 실패.")
            return .just(.failure(error))
        }
        
        if fileName.split(separator: ".").last ?? "" != "otf" {
            let error = FTError.error("올바르지 않은 파일입니다.")
            return .just(.failure(error))
        }

        let filePath = folderPath + "/" + fileName
        if FontManagerImpl.shared.isAlreadyFont(filePath) {
            let error = FTError.error("이미 존재하는 폰트입니다.")
            return .just(.failure(error))
        }
        
        return Observable.create { observer -> Disposable in
            let task = self.session.dataTask(with: urlComp) { (data, _, error) in
                if let error = error {
                    observer.onNext(.failure(.error(error.localizedDescription)))
                    observer.onCompleted()
                    return
                }
                
                if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
                    print("파일 저장 위치 \(filePath)")
                    observer.onNext(.success(filePath))
                    observer.onCompleted()
                    return
                }
                
                observer.onNext(.failure(.error("파일 저장 실패")))
                observer.onCompleted()
            }
            
            task.resume()
            return Disposables.create()
        }
    }
}
