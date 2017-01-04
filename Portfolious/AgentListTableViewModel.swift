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

typealias KeyType = Hashable & Equatable

protocol AgentListTableViewModelDelegate: class {
    func updateWith(_ viewModel: AgentListTableViewModel)
}

struct AgentListTableViewModel {
    weak var delegate:AgentListTableViewModelDelegate?
    var users = [User]() {
        didSet {
            self.delegate?.updateWith(self)
        }
    }
	
	// this is where the magic happens 🎉
    mutating func getUsers() {
		// ugly copy: http://stackoverflow.com/questions/38058280/modifying-struct-instance-variables-within-a-dispatch-closure-in-swift
		var copy = self
        JSONPlaceholder
			.request(endpoint: "users")
			.startWithResult { (result: Result<[AnyObject], NetworkError>) in
				switch result {
				case .success(let networkUsers):
					copy.users = networkUsers.flatMap {
						User.decode(JSON($0)).value
					}
				case .failure(let error):
					print("error: \(error)")
				}
		}
		
		self = copy
    }
    
    func agentOverviewModel(atIndex index: Int) -> AgentOverviewViewModel? {
        if users.indices.contains(index) {
            return AgentOverviewViewModel(user: users[index])
        } else {
            return nil
        }
    }
    
    func cell(forIndexPath indexPath: IndexPath, onTableView tableView: UITableView) -> AgentOverviewTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainStoryboard.ReuseIdentifiers.AgentPortfolioCell) as! AgentOverviewTableViewCell
        if users.indices.contains(indexPath.row) {
            let user = users[indexPath.row]
            
            cell.agentName?.text = user.name
        }
        return cell
    }
}
