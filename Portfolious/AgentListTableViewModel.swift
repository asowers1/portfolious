//
//  AgentListTableViewModel.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import ReactiveJSON
import Result
import Argo
import UIKit

protocol AgentListTableViewModelDelegate: class {
    func updateWith(viewModel: AgentListTableViewModel)
}

struct AgentListTableViewModel {
    weak var delegate:AgentListTableViewModelDelegate?
    var users = [User]() {
        didSet {
            self.delegate?.updateWith(self)
        }
    }
    
    mutating func getUsers() {
        JSONPlaceholder
            .request(endpoint: "users")
            .collect()
            .startWithResult { (result: Result<[AnyObject], NetworkError>) in
                switch result {
                case .Success(let users):
                    var newUsers = [User]()
                    users.forEach {
                        if let user = User.decode(JSON($0)).value {
                            newUsers.append(user)
                        }
                    }
                    self.users = newUsers
                case .Failure(let error):
                    print("Error: \(error)")
                }
        
        }
    }
    
    func agentOverviewModel(atIndex index: Int) -> AgentOverviewViewModel? {
        if users.indices.contains(index) {
            return AgentOverviewViewModel(user: users[index])
        } else {
            return nil
        }
    }
    
    func cell(forIndexPath indexPath: NSIndexPath, onTableView tableView: UITableView) -> AgentOverviewTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.ReuseIdentifiers.AgentPortfolioCell) as! AgentOverviewTableViewCell
        if users.indices.contains(indexPath.row) {
            let user = users[indexPath.row]
            
            cell.agentName?.text = user.name
        }
        return cell
    }
}