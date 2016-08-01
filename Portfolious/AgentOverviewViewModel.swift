//
//  AgentOverviewViewModel.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/31/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation

struct AgentOverviewViewModel {
    let user: User
    
    var navigationTitle: String {
        return user.name
    }
    
    init(user: User) {
        self.user = user
    }
    
}