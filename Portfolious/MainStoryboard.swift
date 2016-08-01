//
//  MainStoryboard.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation

struct MainStoryboard {
    struct SceneIdentifiers {
        
        //MARK- ViewControllers
        static let AgentListTableViewController = "AgentListTableViewController"
        static let AgentOverviewViewController = "AgentOverviewViewController"
        static let AgentAlbumsTableViewControler = "AgentAlbumsTableViewController"
        static let AgentAlbumCollectionViewController = "AgentAlbumCollectionViewController"
        static let AgentDetailsContainerViewController = "AgentDetailsViewCntroler"
        
        //MARK- cells
        static let AgentOverviewTableViewCell = "AgentOverviewTableViewCell"
        static let AgentAlbumTableViewCell = "AgentAlbumTableViewCell"
        static let AgentPhotoCollectionViewCell = "AgentPhotoCollectionViewCell"
    }
    struct Segues {
        static let AgentOverviewViewControllerSegue = "AgentOverviewViewControllerSegue"
        static let AgentAlbumsTableViewControllerContainerSegue = "AgentAlbumsTableViewControllerContainerSegue"
        static let AgentAlbumCollectionViewControllerSegue = "AgentAlbumCollectionViewControllerSegue"
        static let AgentDetailsContainerViewControllerSegue = "AgentDetailsContainerViewControllerSegue"
        static let AgentAlbumsTableViewControllerSegue = "AgentAlbumsTableViewControllerSegue"
    }
    struct ReuseIdentifiers {
        static let AgentPortfolioCell = "AgentPortfolioCell"
        static let AgentAlbumCell = "AgentAlbumCell"
        static let AgentPhotoCell = "AgentPhotoCell"
    }
}