//
//  AlbumPhotosViewModel.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/31/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import Argo
import Result
import UIKit
import ReactiveJSON

protocol AlbumPhotosViewModelDelegate: class {
    func didUpdateWith(_ viewModel: AlbumPhotosViewModel)
}

struct AlbumPhotosViewModel {
	
	var album: Album
	var photos: [Photo] = [Photo]() {
        didSet {
            delegate?.didUpdateWith(self)
        }
    }
	
	var navigationTitle: String {
        return album.title
    }
	
	weak var delegate: AlbumPhotosViewModelDelegate?
	
	init(album: Album) {
        self.album = album
    }
	
	// this is where the magic happens 🎉
    mutating func getPhotos() {
		let endpoint = "photos/?albumId=\(album.id)"
		// ugly copy: http://stackoverflow.com/questions/38058280/modifying-struct-instance-variables-within-a-dispatch-closure-in-swift
		var copy = self
		JSONPlaceholder
			.request(endpoint: endpoint)
			.collect()
			.startWithResult { (result: Result<[AnyObject], NetworkError>) in
				switch result {
				case .success(let photos):
					copy.photos = photos.flatMap {
						Photo.decode(JSON($0)).value
					}
				case .failure(let error):
					print("Error: \(error)")
				}
			}
		self = copy
	}
	
	
	
    func imageView(forIndexPath indexPath: IndexPath, andImageView imageView: UIImageView?) {
        imageView?.imageFromServerURL(photos[indexPath.row].url)
    }
    
    func cell(forIndexPath indexPath: IndexPath, onCollectionView collectionView: UICollectionView) -> AgentPhotoCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainStoryboard.ReuseIdentifiers.AgentPhotoCell, for: indexPath) as! AgentPhotoCollectionViewCell
        imageView(forIndexPath: indexPath, andImageView: cell.imageView)
        return cell
    }
}
