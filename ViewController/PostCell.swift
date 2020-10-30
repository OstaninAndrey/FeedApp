//
//  PostCell.swift
//  FeedApp
//
//  Created by Андрей Останин on 01.10.2020.
//

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: - Properties
    private let userImage = UIImageView()
    private let nameLabel = UILabel()
    private let postTextLabel = UILabel()
    private let postImage = UIImageView()
    private let likesLabel = UILabel()
    private let viewsLabel = UILabel()
    
    private let userInfoStack = UIStackView()
    private let statsStack = UIStackView()
    private let postStack = UIStackView()
    
    private var postVM: PostViewModel?
    
    // MARK: - Cell lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        postVM?.getPostImage { (image) in
            DispatchQueue.main.async {
                self.postImage.image = image
            }
        }
        
        postTextLabel.text = post.postTextLabel()
        
        nameLabel.text = post.name
        likesLabel.text = "Likes: \(post.likes)"
        viewsLabel.text = "Views: \(post.views)"
    }
    
    // MARK: - Configuring UI methods
    private func configureStackView() {
        contentView.addSubview(userInfoStack)
        
        userInfoStack.axis = .horizontal
        userInfoStack.spacing = 15
        userInfoStack.alignment = .firstBaseline
        
        userInfoStack.addArrangedSubview(userImage)
        userInfoStack.addArrangedSubview(nameLabel)
        
        contentView.addSubview(statsStack)
        
        statsStack.axis = .horizontal
        statsStack.spacing = 20
        statsStack.alignment = .firstBaseline
        
        statsStack.addArrangedSubview(likesLabel)
        statsStack.addArrangedSubview(viewsLabel)
        
        contentView.addSubview(postStack)
        
        postStack.axis = .vertical
        postStack.spacing = 20
        
        postStack.addArrangedSubview(userInfoStack)
        postStack.addArrangedSubview(postTextLabel)
        postTextLabel.numberOfLines = 4
        postStack.addArrangedSubview(postImage)
        postStack.addArrangedSubview(statsStack)
        setupUserImageConstraints()
        setupPostStackConstraints()
        setupPostImageAspectRatio()
    }
    
    private func setupPostStackConstraints() {
        postStack.translatesAutoresizingMaskIntoConstraints = false
        postStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        postStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        postStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        postStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
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
        postImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: ratio).isActive = true
    }
    
    
}

