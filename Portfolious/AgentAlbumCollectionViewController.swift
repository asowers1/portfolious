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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = viewModel?.navigationTitle ?? "Photos"
    }
}

//MARK- CollectionView delegation
extension AgentAlbumCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did the thing at \(indexPath)")
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel!.cell(forIndexPath: indexPath, onCollectionView: collectionView)
    }
}

//MARK- ViewModel delegation
extension AgentAlbumCollectionViewController: AlbumPhotosViewModelDelegate {
    func didUpdateWith(_ viewModel: AlbumPhotosViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel = viewModel
            self?.collectionView?.reloadData()
        }
    }
}
