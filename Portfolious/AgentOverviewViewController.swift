//
//  AgentOverviewViewController
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class AgentOverviewViewController: UIViewController {
    
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var agentPhone: UILabel!
    @IBOutlet weak var agentEmail: UILabel!
    @IBOutlet weak var agentCompany: UILabel!
    @IBOutlet weak var agentAvatar: UIImageView!
    
    weak var agentDetailsContainerViewController: AgentDetailsContainerViewController?
    weak var agentAlbumsTableViewController: AgentAlbumsTableViewControler?
    
    var viewModel: AgentOverviewViewModel?

    override func viewWillAppear(_ animated: Bool) {
        if let viewModel = viewModel {
            setupWith(viewModel: viewModel)
        }
    }
    
    func setupWith(viewModel: AgentOverviewViewModel) {
        agentDetailsContainerViewController?.agentName?.text = viewModel.user.name
        agentDetailsContainerViewController?.agentEmail?.text = viewModel.user.email
        agentDetailsContainerViewController?.agentPhone?.text = viewModel.user.phone
        navigationItem.title = viewModel.navigationTitle
    }
}

//MARK- Dependency Injection
extension AgentOverviewViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case MainStoryboard.Segues.AgentDetailsContainerViewControllerSegue:
                if let vc = segue.destination as? AgentDetailsContainerViewController {
                    agentDetailsContainerViewController = vc
                }
            case MainStoryboard.Segues.AgentAlbumsTableViewControllerContainerSegue:
                if let vc = segue.destination as? AgentAlbumsTableViewControler {
                    vc.user = viewModel?.user
                    agentAlbumsTableViewController = vc
                }
            case MainStoryboard.Segues.AgentAlbumCollectionViewControllerSegue:
                if let vc = segue.destination as? AgentAlbumCollectionViewController {
                    vc.album = agentAlbumsTableViewController?.viewModel?.albums[(agentAlbumsTableViewController?.tableView.indexPathForSelectedRow?.row ?? -1)]
                }
            default: break
            }
        }
    }
}
