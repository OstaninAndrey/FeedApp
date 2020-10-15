//
//  ViewController.swift
//  FeedApp
//
//  Created by Андрей Останин on 30.09.2020.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView = UITableView()
    private let orderLabel = UILabel()
    private let orderByDateButton = UIButton()
    private let orderByCommentsButton = UIButton()
    private let orderByPopularityButton = UIButton()
    private let orderStackView = UIStackView()
    private let stackView = UIStackView()
    private var aiView = UIView()
    
    var feedViewModel = FeedViewModel()
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: K.scrollBackground)
        title = "FeedApp"
        feedViewModel.delegate = self
        setupTableView()
        setupSortingUI()
        setConstraints()
        
        feedViewModel.fetchFeed(orderBy: .createdAt, clearPrevious: false) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Configureing UI methods
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(PostCell.self, forCellReuseIdentifier: K.postCell)
    }
    
    private func setupSortingUI() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        
        orderStackView.axis = .horizontal
        orderStackView.spacing = 10
        orderStackView.alignment = .center
        
        
        orderStackView.addArrangedSubview(orderLabel)
        orderStackView.addArrangedSubview(orderByPopularityButton)
        orderStackView.addArrangedSubview(orderByCommentsButton)
        orderStackView.addArrangedSubview(orderByDateButton)
        
        orderLabel.text = "Order by:"
        orderByPopularityButton.setTitle("Pop", for: .normal)
        orderByPopularityButton.setTitleColor(.systemBlue, for: .normal)
        orderByPopularityButton.setTitleColor(.gray, for: .highlighted)
        orderByPopularityButton.addTarget(self, action: #selector(popularButtonPressed), for: .touchUpInside)
        
        orderByDateButton.setTitle("Date", for: .normal)
        orderByDateButton.setTitleColor(.systemBlue, for: .normal)
        orderByDateButton.setTitleColor(.gray, for: .highlighted)
        orderByDateButton.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
        
        orderByCommentsButton.setTitle("Comments", for: .normal)
        orderByCommentsButton.setTitleColor(.systemBlue, for: .normal)
        orderByCommentsButton.setTitleColor(.gray, for: .highlighted)
        orderByCommentsButton.addTarget(self, action: #selector(commentsButtonPressed), for: .touchUpInside)

        
        view.addSubview(stackView)
        stackView.addArrangedSubview(orderStackView)
        stackView.addArrangedSubview(tableView)
    }
    
    private func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        orderStackView.translatesAutoresizingMaskIntoConstraints = false
        orderByCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        orderByPopularityButton.translatesAutoresizingMaskIntoConstraints = false
        orderByDateButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        orderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        orderByCommentsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        orderByPopularityButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        orderByDateButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func showActivityIndicator() {
        aiView = UIView(frame: self.view.bounds)
        aiView.backgroundColor = UIColor(named: K.scrollBackground)?.withAlphaComponent(0.9)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aiView.center
        
        view.addSubview(aiView)
        aiView.addSubview(ai)
        
        ai.startAnimating()
    }

    private func removeActivityIndicator() {
        aiView.removeFromSuperview()
    }
    
    // MARK: - Actions
    @objc private func dateButtonPressed() {
        feedViewModel.fetchFeed(orderBy: .createdAt, clearPrevious: true) {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @objc private func popularButtonPressed() {
        feedViewModel.fetchFeed(orderBy: .mostPopular, clearPrevious: true) {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @objc private func commentsButtonPressed() {
        feedViewModel.fetchFeed(orderBy: .mostCommented, clearPrevious: true) {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
}

// MARK: - TableView delegate
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.postCell) as! PostCell
        cell.setPostViewModel(postVM: feedViewModel.post(for: indexPath.row))
    
        feedViewModel.checkIfTheLast(index: indexPath.row) {
            tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailsVC = DetailsViewController()
        detailsVC.setPostViewModel(postVM: feedViewModel.post(for: indexPath.row))
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

// MARK: - FeedViewModel delegate
extension FeedViewController: FeedViewModelDelegate {
    func startedLoading() {
        showActivityIndicator()
    }
    
    func endedLoading() {
        removeActivityIndicator()
    }
    
    
}
