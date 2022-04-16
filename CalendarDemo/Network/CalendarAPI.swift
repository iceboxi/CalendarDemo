//
//  CalendarAPI.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import Foundation
import Moya

protocol RequestRoutable {
    var controllerName: String { get }
}

enum CalendarAPI: RequestRoutable {
    case getSchedule(week: Int)
    
    var controllerName: String {
        return "/teachers/amy-estrada"
    }
}

extension CalendarAPI: TargetType {
    var headers: [String: String]? {
        nil
    }
    
    var baseURL: URL {
        return URL(string: "https://tw.amazingtalker.com/v1/guest")!
    }
    
    var path: String {
        let endPoint: String
        
        switch self {
        case .getSchedule:
            endPoint = "schedule"
        }
        
        return "\(controllerName)/\(endPoint)"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getSchedule(let week):
            return .requestParameters(parameters: ["week": week], encoding: parameterEncoding)
        }
    }

    var sampleData: Data {
        var dataUrl: URL?
        switch self {
        case .getSchedule: dataUrl = R.file.scheduleJson()
        }
        if let url = dataUrl, let data = try? Data(contentsOf: url) {
            return data
        }
        return Data()
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}
