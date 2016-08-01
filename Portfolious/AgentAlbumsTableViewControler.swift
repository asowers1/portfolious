//
//  AgentAlbumsTableViewControler.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import UIKit

class AgentAlbumsTableViewControler: UITableViewController {

    var user: User?
    var viewModel: AgentAlbumViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        if let user = user {
            viewModel = AgentAlbumViewModel(user: user)
            viewModel?.delegate = self
            viewModel?.getAlbums()
        }
    }
}

//MARK- TableView Delegateion
extension AgentAlbumsTableViewControler {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.albums.count ?? 0
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        parentViewController?.performSegueWithIdentifier(MainStoryboard.Segues.AgentAlbumCollectionViewControllerSegue, sender: parentViewController)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.ReuseIdentifiers.AgentAlbumCell) as! AgentAlbumTableViewCell
        if let vm = viewModel {
            cell.albumName?.text = vm.albums[indexPath.row].title
        }
        return cell
    }
}

extension AgentAlbumsTableViewControler: AgentAlbumViewModelDelegate {
    func didUpdateAlbumsModel(withModel model: AgentAlbumViewModel) {
        viewModel = model
        tableView?.reloadData()
    }
}
