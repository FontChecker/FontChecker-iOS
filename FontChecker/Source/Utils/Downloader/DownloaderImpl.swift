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

    func createDirectory(dirName: String = FileConstant.Path.baseDirName) -> String? {
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
        
        guard let filePath = createDirectory(),
            let fileName = url.split(separator: "/").last else {
            let error = FTError.error("파일 생성 실패.")
            return .just(.failure(error))
        }
        
        return Observable.create { observer -> Disposable in
            let task = self.session.dataTask(with: urlComp) { (data, _, error) in
                if let error = error {
                    observer.onNext(.failure(.error(error.localizedDescription)))
                    observer.onCompleted()
                    return
                }
                
                let file = filePath + "/" + fileName
                if FileManager.default.createFile(atPath: file, contents: data, attributes: nil) {
                    print("파일 저장 위치 \(file)")
                    observer.onNext(.success(file))
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
