//
//  FetchThumbnailUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation
import LinkPresentation

import RxSwift
import SwiftSoup

public protocol FetchThumbnailUseCase {
  func execute(url: URL) -> Single<Thumbnail?>
}

public class FetchThumbnailUseCaseImpl: FetchThumbnailUseCase {

  private let metadataProvider: LPMetadataProvider

  public init(metadataProvider: LPMetadataProvider) {
    self.metadataProvider = metadataProvider
  }

  public func execute(url: URL) -> Single<Thumbnail?> {
    Single.create { single in
      let task = Task {
        do {
          let html = try String(contentsOf: url)
          let doc: Document = try SwiftSoup.parse(html)

          // 링크 썸네일 이미지 URL을 추출합니다.
          var thumbnailUrl: String?
          if let imageElement = try doc.select("meta[property=og:image]").first(),
             let imageUrl = try? imageElement.attr("content") {
            thumbnailUrl = imageUrl
          }

          // 메타데이터의 제목을 추출합니다.
          var title: String?
          if let titleElement = try doc.select("meta[property=og:title]").first(),
             let pageTitle = try? titleElement.attr("content") {
            title = pageTitle
          }

          // 원본 URL을 사용합니다.
          let linkUrl = url.absoluteString

          // 추출한 정보로 LinkMetadata 객체를 생성합니다.
          if title == nil, thumbnailUrl == nil {
            single(.success(nil))
          } else {
            let metadata = Thumbnail(title: title, url: linkUrl, imageURL: thumbnailUrl)
            single(.success(metadata))
          }
        } catch {
          single(.failure(error))
        }
      }

      return Disposables.create {
        task.cancel()
      }
    }
    .observe(on: MainScheduler.instance)
  }
}
