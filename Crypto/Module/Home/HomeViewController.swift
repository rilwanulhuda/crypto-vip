//
//  HomeViewController.swift
//  Cryptocurrencys
//
//  Created by Rilwanul Huda on 13/07/21.
//

import UIKit

protocol IHomeViewController: AnyObject {
    var router: IHomeRouter? { get set }
    
    func displayTopList(topListCoins: [TopListModel], coinsCount: Int, subscriptions: [String])
    func displayTopListError(message: String)
    func displayLoadMoreTopList(topListCoins: [TopListModel], indexPaths: [IndexPath], subscriptions: [String])
    func displayLoadMoreTopListError(message: String)
    func displayRefreshCoins(topListCoins: [TopListModel], at indexPath: IndexPath)
}

class HomeViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var homeTableView: UITableView!
    
    var interactor: IHomeInteractor?
    var router: IHomeRouter?
    var loadingView: LoadingView!
    var topListCoins: [TopListModel] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshTopList), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        getTopList()
    }
    
    private func setupComponent() {
        title = "Cryptocurrencys"
        homeTableView.refreshControl = refreshControl
        homeTableView.registerCellType(TopListTableViewCell.self)
        
        loadingView = LoadingView()
        loadingView.setup(in: contentView)
        loadingView.reloadButton.touchUpInside(self, action: #selector(getTopList))
    }
    
    @objc private func getTopList() {
        loadingView.start { [weak self] in
            guard let self = self else { return }
            self.interactor?.getTopList()
        }
    }
    
    @objc private func refreshTopList() {
        interactor?.getTopList()
    }
}

extension HomeViewController: IHomeViewController {
    func displayTopList(topListCoins: [TopListModel], coinsCount: Int, subscriptions: [String]) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        self.topListCoins = topListCoins
        homeTableView.reloadData()
        loadingView.stop()
        
        interactor?.coinsCount = coinsCount
        interactor?.currentCoinsCount = topListCoins.count
        interactor?.subscriptions = subscriptions
        interactor?.sendSubscription(action: .subscribe)
    }
    
    func displayTopListError(message: String) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
            Toast.share.show(message: message)
        } else {
            loadingView.stop(isFailed: true, message: message)
        }
    }
    
    func displayLoadMoreTopList(topListCoins: [TopListModel], indexPaths: [IndexPath], subscriptions: [String]) {
        guard topListCoins.count > self.topListCoins.count else { return }
        self.topListCoins = topListCoins
        interactor?.subscriptions = subscriptions
        interactor?.sendSubscription(action: .subscribe)
        homeTableView.performBatchUpdates({
            self.homeTableView.insertRows(at: indexPaths, with: .top)
        }, completion: nil)
    }
    
    func displayLoadMoreTopListError(message: String) {
        Toast.share.show(message: message)
    }
    
    func displayRefreshCoins(topListCoins: [TopListModel], at indexPath: IndexPath) {
        self.topListCoins = topListCoins
        homeTableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topListCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TopListTableViewCell.self, for: indexPath)
        let coin = topListCoins[indexPath.row]
        cell.setupView(coin: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == topListCoins.count - 1 {
            if interactor?.couldLoadMore() == true {
                interactor?.loadMoreTopList()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = topListCoins[indexPath.row].symbol
        router?.showNews(of: symbol)
    }
}
