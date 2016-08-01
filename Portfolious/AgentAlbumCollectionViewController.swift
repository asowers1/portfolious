//
//  AgentAlbumCollectionViewController.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import UIKit

class AgentAlbumCollectionViewController: UICollectionViewController {
    var viewModel: AlbumPhotosViewModel?
    var album: Album?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.delegate = self
        if let album = album {
            viewModel = AlbumPhotosViewModel(album: album)
            viewModel?.delegate = self
            viewModel?.getPhotos()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = viewModel?.navigationTitle ?? "Photos"
    }
}

//MARK- CollectionView delegation
extension AgentAlbumCollectionViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("did the thing at \(indexPath)")
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return viewModel!.cell(forIndexPath: indexPath, onCollectionView: collectionView)
    }
}

//MARK- ViewModel delegation
extension AgentAlbumCollectionViewController: AlbumPhotosViewModelDelegate {
    func didUpdateWith(viewModel viewModel: AlbumPhotosViewModel) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.viewModel = viewModel
            self?.collectionView?.reloadData()
        }
    }
}