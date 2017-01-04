//
//  AgentListTableViewController.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class AgentListTableViewController: UITableViewController {
    var viewModel = AgentListTableViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        viewModel.delegate = self
        viewModel.getUsers()
        
    }
}

//MARK- ViewModel Delegate
extension AgentListTableViewController: AgentListTableViewModelDelegate {
    func updateWith(_ viewModel: AgentListTableViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            self.tableView?.reloadData()
        }
    }
}

//MARK- TableView delegate methods
extension AgentListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did the thing at \(indexPath)")
        performSegue(withIdentifier: MainStoryboard.Segues.AgentOverviewViewControllerSegue, sender: self)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(forIndexPath: indexPath, onTableView: tableView)
    }
}

//MARK- Dependency Injection
extension AgentListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AgentOverviewViewController, let agentOverviewViewModel = viewModel.agentOverviewModel(atIndex: (tableView?.indexPathForSelectedRow?.row ?? -1)) {
            vc.viewModel = agentOverviewViewModel
        }
    }
}
