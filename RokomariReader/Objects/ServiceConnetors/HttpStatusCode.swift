//
//  HttpStatusCode.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 8/2/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

enum HttpStatusCode: Int {
    
    case OK = 200
    case Created = 201
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case PoxyAuthRequired = 407
    case RequestTimeout = 408
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HttpVersionNotSupported = 505
}