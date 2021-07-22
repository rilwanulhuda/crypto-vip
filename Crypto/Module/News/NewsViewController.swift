//
//  NewsViewController.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

//
//  NewsViewController.swift
//  Cryptocurrencys
//
//  Created by Rilwanul Huda on 13/07/21.
//

import UIKit

protocol INewsViewController {
    var router: INewsRouter? { get set }
    
    func displayNews(news: [NewsModel])
    func displayNewsError(message: String)
}

class NewsViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var newsTableView: UITableView!
    
    var interactor: INewsInteractor?
    var router: INewsRouter?
    var loadingView: LoadingView!
    var news: [NewsModel] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        getNews()
    }
    
    private func setupComponent() {
        newsTableView.refreshControl = refreshControl
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissView))
        newsTableView.registerCellType(NewsTableViewCell.self)
        
        let symbol = interactor?.parameters?["symbol"] as? String
        title = symbol != nil ? "\(symbol!) News" : "Crypto News"
        
        loadingView = LoadingView()
        loadingView.setup(in: contentView)
        loadingView.reloadButton.touchUpInside(self, action: #selector(getNews))
        
    }
    
    @objc private func getNews() {
        loadingView.start { [weak self] in
            guard let self = self else { return }
            self.interactor?.getNews()
        }
    }
    
    @objc func refreshNews() {
        interactor?.getNews()
    }
    
    @objc func dismissView() {
        dismiss()
    }
}
    
extension NewsViewController: INewsViewController {
    func displayNews(news: [NewsModel]) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        self.news = news
        newsTableView.reloadData()
        loadingView.stop()
    }
    
    func displayNewsError(message: String) {
        if refreshControl.isRefreshing {
            Toast.share.show(message: message) { [weak self] in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
            }
        } else {
            loadingView.stop(isFailed: true, message: message)
        }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NewsTableViewCell.self, for: indexPath)
        let news = self.news[indexPath.row]
        cell.setupView(news: news)
        
        cell.handleUpdateCell = {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.news[indexPath.row]
        print(news)
    }
}

