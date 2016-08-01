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
    
    mutating func getAlbums() {
        JSONPlaceholder
            .request(endpoint: "albums/?userId=\(user.id)")
            .collect()
            .startWithResult { (result: Result<[AnyObject], NetworkError>) in
                switch result {
                case .Success(let albums):
                    var newAlbums = [Album]()
                    albums.forEach({
                        if let album = Album.decode(JSON($0)).value {
                            newAlbums.append(album)
                        }
                    })
                    self.albums = newAlbums
                case .Failure(let error):
                    print("Error: \(error)")
                }
        }
    }
    
    func cell(forIndexPath indexPath: NSIndexPath, onTableView tableView: UITableView) -> AgentAlbumTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.ReuseIdentifiers.AgentAlbumCell) as! AgentAlbumTableViewCell
        cell.albumName?.text = albums[indexPath.row].title
        return cell
    }
}