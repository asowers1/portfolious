//
//  AgentAlbumViewModel.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/31/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import ReactiveJSON
import Argo
import Result
import UIKit

protocol AgentAlbumViewModelDelegate: class {
    func didUpdateAlbumsModel(withModel model: AgentAlbumViewModel)
}

struct AgentAlbumViewModel {
    
    let user: User
    var albums: [Album] = [Album]() {
        didSet {
            delegate?.didUpdateAlbumsModel(withModel: self)
        }
    }
    
    weak var delegate: AgentAlbumViewModelDelegate?
    
    init(user: User) {
        self.user = user
    }
	
	// this is where the magic happens 🎉
    mutating func getAlbums() {
		let endpoint = "albums/?userId=\(user.id)"
		// ugly copy: http://stackoverflow.com/questions/38058280/modifying-struct-instance-variables-within-a-dispatch-closure-in-swift
		var copy = self
		JSONPlaceholder.request(endpoint: endpoint)
			.collect()
			.startWithResult { (result: Result<[AnyObject], NetworkError>) in
				switch result {
				case .success(let albums):
					copy.albums = albums.flatMap {
						Album.decode(JSON($0)).value
					}
				case .failure(let error):
					print("Error: \(error)")
				}
			}
		self = copy
    }
    
    func cell(forIndexPath indexPath: IndexPath, onTableView tableView: UITableView) -> AgentAlbumTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainStoryboard.ReuseIdentifiers.AgentAlbumCell) as! AgentAlbumTableViewCell
        cell.albumName?.text = albums[indexPath.row].title
        return cell
    }
}
