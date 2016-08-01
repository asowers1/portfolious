//
//  JSONPlaceholderClient.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import ReactiveJSON

public struct JSONPlaceholder: JSONService, ServiceHostType {
    private static let _sharedInstance = InstanceType()
    //--------------------------------------------------------------------------
    // protocol: JSONService
    public typealias InstanceType = JSONPlaceholder
    public static func sharedInstance() -> InstanceType {
        return _sharedInstance
    }
    //--------------------------------------------------------------------------
    // protocol: ServiceHostType
    public static var scheme: String { return "http" }
    public static var host: String { return "jsonplaceholder.typicode.com" }
    public static var path: String? { return nil }
    //--------------------------------------------------------------------------
}

public struct Placeholder: JSONService, ServiceHostType {
    private static let _sharedInstance = InstanceType()
    //--------------------------------------------------------------------------
    // protocol: JSONService
    public typealias InstanceType = Placeholder
    public static func sharedInstance() -> InstanceType {
        return _sharedInstance
    }
    //--------------------------------------------------------------------------
    // protocol: ServiceHostType
    public static var scheme: String { return "http" }
    public static var host: String { return "placehold.it" }
    public static var path: String? { return nil }
    //--------------------------------------------------------------------------
}