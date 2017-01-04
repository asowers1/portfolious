//
//  JSONPlaceholderClient.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import ReactiveJSON

/// A JSON client for the JSONPlaceholder API
struct JSONPlaceholder: Singleton, ServiceHost {
	// 'Singleton'
	fileprivate(set) static var shared = Instance()
	typealias Instance = JSONPlaceholder
	
	// 'ServiceHost'
	static var scheme: String { return "https" }
	static var host: String { return "jsonplaceholder.typicode.com" }
	static var path: String? { return nil }
}
