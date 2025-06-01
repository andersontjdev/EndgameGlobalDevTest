//
//  UserCellTemplate.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import UIKit

class UserCellTemplate: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    // MARK: UI Elements
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    private var imageLoadingTask: URLSessionDataTask?
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        usernameLabel.text = nil
        imageLoadingIndicator.stopAnimating()
        imageLoadingTask?.cancel()
        imageLoadingTask = nil
    }
    
    // MARK: Public Functions
    
    func configure(with user: User) {
        usernameLabel.text = user.login
        
        // Load the avatar image
        if let avatarUrlString = user.avatarUrl {
            loadAvatarImage(from: avatarUrlString)
        } else {
            setPlaceholderAvatar()
        }
    }
    
    // MARK: Private Functions
    
    private func setupUI() {
        selectionStyle = .default
        backgroundColor = .systemBackground
        
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(imageLoadingIndicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Avatar image view constraints
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Username label constraints
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // Loading indicator contraints
            imageLoadingIndicator.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            imageLoadingIndicator.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            // Minimum height constraint
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    private func loadAvatarImage(from urlString: String) {
        // Show the loading indicator
        imageLoadingIndicator.startAnimating()
        
        // While loading, user the default placeholder avatar
        setPlaceholderAvatar()
        
        // Load the image
        ImageLoadingService.shared.loadImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageLoadingIndicator.stopAnimating()
                
                if let image = image {
                    self?.avatarImageView.image = image
                    self?.avatarImageView.tintColor = nil
                } else {
                    self?.setPlaceholderAvatar()
                }
            }
        }
    }
    
    private func setPlaceholderAvatar() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let avatarimage = UIImage(systemName: "person.circle", withConfiguration: configuration)
        avatarImageView.image = avatarimage
        avatarImageView.tintColor = .systemGray
    }
    
}
