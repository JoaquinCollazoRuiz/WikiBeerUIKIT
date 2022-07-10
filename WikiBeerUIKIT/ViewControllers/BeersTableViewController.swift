//
//  BeersTableViewController.swift
//  WikiBeerUIKIT
//
//  Created by Joaquin on 9/7/22.
//

import UIKit

class BeersTableViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let dataSource = BeersDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitleView()
        configureNavigationBar()

        view.backgroundColor = AppColor.background

        tableView.separatorColor = .darkGray
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = dataSource
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        BeerService().getBeers { beers in
            DispatchQueue.main.async {
                self.dataSource.append(beers)
                self.tableView.reloadData()
            }
        }
    }

    func configureTitleView() {
        let titleLabel = UILabel()
        titleLabel.textColor = .white

        let title = NSMutableAttributedString(string: "Beer ",
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .light)])
        title.append(NSMutableAttributedString(string: "Box",
                                               attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        titleLabel.attributedText = title
        navigationItem.titleView = titleLabel
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = AppColor.background
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beer = dataSource.getBeer(at: indexPath.row)
        let beerDetails = BeerDetails(title: beer.name,
                                      subtitle: beer.tagline,
                                      details: beer.description,
                                      imageURL: beer.imageURL)
        let detailsViewController = BeerDetailsViewController(beerDetails: beerDetails)
        detailsViewController.modalPresentationStyle = .pageSheet
        showDetailViewController(detailsViewController, sender: self)
    }
}

extension BeersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchKey = searchController.searchBar.text

        BeerService().getBeers(searchKey: searchKey) { beers in
            DispatchQueue.main.async {
                self.dataSource.setSearchKey(searchKey: searchKey)
                self.dataSource.append(beers)
                self.tableView.reloadData()
            }
        }
    }
}
