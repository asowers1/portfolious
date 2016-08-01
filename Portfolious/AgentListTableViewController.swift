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
    func updateWith(viewModel: AgentListTableViewModel) {
        dispatch_async(dispatch_get_main_queue()) {
            self.viewModel = viewModel
            self.tableView?.reloadData()
        }
    }
}

//MARK- TableView delegate methods
extension AgentListTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did the thing at \(indexPath)")
        performSegueWithIdentifier(MainStoryboard.Segues.AgentOverviewViewControllerSegue, sender: self)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return viewModel.cell(forIndexPath: indexPath, onTableView: tableView)
    }
}

//MARK- Dependency Injection
extension AgentListTableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? AgentOverviewViewController, let agentOverviewViewModel = viewModel.agentOverviewModel(atIndex: (tableView?.indexPathForSelectedRow?.row ?? -1)) {
            vc.viewModel = agentOverviewViewModel
        }
    }
}