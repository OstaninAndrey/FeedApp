//
//  DetailsViewController.swift
//  FeedApp
//
//  Created by Андрей Останин on 03.10.2020.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Properties
    private var postVM: PostViewModel?
    
    private var scrollView = UIScrollView()
    
    private let userImage = UIImageView()
    private let nameLabel = UILabel()
    private let postTextLabel = UILabel()
    private let postImage = UIImageView()
    private let likesLabel = UILabel()
    private let viewsLabel = UILabel()
    
    private let userInfoStack = UIStackView()
    private let statsStack = UIStackView()
    private let postStack = UIStackView()
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FeedApp"
        view.backgroundColor = UIColor(named: K.scrollBackground)
        setupScrollView()
    }
    
    // MARK: - Data load
    func setPostViewModel(postVM: PostViewModel) {
        self.postVM = postVM
        self.postVM!.parseContent()
        fillData()
    }
    
    private func fillData() {
        guard let post = postVM else { return }
        
        userImage.image = UIImage(named: "userImage")
        nameLabel.text = post.name
        
        postVM?.loadImage(completion: { (image) in
            self.postImage.image = image
        })
        
        postTextLabel.text = post.postTextLabel()
        
        likesLabel.text = "Likes: \(post.likes)"
        viewsLabel.text = "Views: \(post.views)"
    }
    
    // MARK: - Configuring UI methods
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        configureStackViews()
    }
    
    private func configureStackViews() {
        scrollView.addSubview(userInfoStack)
        
        userInfoStack.axis = .horizontal
        userInfoStack.spacing = 15
        userInfoStack.alignment = .firstBaseline
        
        userInfoStack.addArrangedSubview(userImage)
        userInfoStack.addArrangedSubview(nameLabel)
        
        scrollView.addSubview(statsStack)
        
        statsStack.axis = .horizontal
        statsStack.spacing = 20
        statsStack.alignment = .firstBaseline
        
        statsStack.addArrangedSubview(likesLabel)
        statsStack.addArrangedSubview(viewsLabel)
        
        scrollView.addSubview(postStack)
        
        postStack.axis = .vertical
        postStack.spacing = 20
        
        postStack.addArrangedSubview(userInfoStack)
        postStack.addArrangedSubview(postTextLabel)
        postTextLabel.numberOfLines = 0
        postStack.addArrangedSubview(postImage)
        postStack.addArrangedSubview(statsStack)
        setupUserImageConstraints()
        setupPostStackConstraints()
        setupPostImageAspectRatio()
    }
    
    private func setupPostStackConstraints() {
        postStack.translatesAutoresizingMaskIntoConstraints = false
        postStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        postStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
        postStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15).isActive = true
        postStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15).isActive = true
        postStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
    }
    
    private func setupUserImageConstraints() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupPostImageAspectRatio(for ratio: CGFloat = 1) {
        postImage.constraints.forEach { (constraint) in
            postImage.removeConstraint(constraint)
        }
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.contentMode = .scaleAspectFit
        postImage.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: ratio).isActive = true
    }
    
}
