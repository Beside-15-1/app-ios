//
//  BaseTargetType.swift
//  PBNetworking
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation
import Moya

public protocol BaseTargetType: TargetType, AccessTokenAuthorizable {
}

extension BaseTargetType {
    public var baseURL: URL {
      return URL(string: "https://joosum.com/api")!
    }

    // HTTP header
    //  return ["Content-type": "application/json"]
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }

    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}
