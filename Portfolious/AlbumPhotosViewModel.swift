//
//  AlbumPhotosViewModel.swift
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

protocol AlbumPhotosViewModelDelegate: class {
    func didUpdateWith(viewModel viewModel: AlbumPhotosViewModel)
}

struct AlbumPhotosViewModel {
    var album: Album
    var photos: [Photo] = [Photo]() {
        didSet {
            delegate?.didUpdateWith(viewModel: self)
        }
    }
    var navigationTitle: String {
        return album.title
    }
    weak var delegate: AlbumPhotosViewModelDelegate?
    init(album: Album) {
        self.album = album
    }
    mutating func getPhotos() {
        JSONPlaceholder
            .request(endpoint: "photos/?albumId=\(album.id)")
            .collect()
            .startWithResult { (result: Result<[AnyObject], NetworkError>) in
                switch result {
                case .Success(let photos):
                    var newPhotos = [Photo]()
                    photos.forEach({
                        if let photo = Photo.decode(JSON($0)).value {
                            newPhotos.append(photo)
                        }
                    })
                    self.photos = newPhotos
                case .Failure(let error):
                    print("Error: \(error)")
                }
        }
    }
    
    func imageView(forIndexPath indexPath: NSIndexPath, andImageView imageView: UIImageView?) {
        imageView?.imageFromServerURL(photos[indexPath.row].url)
    }
}