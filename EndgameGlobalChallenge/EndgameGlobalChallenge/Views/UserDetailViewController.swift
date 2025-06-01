//
//  UserDetailViewController.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    private let viewModel: UserDetailViewModel
    
    // MARK: UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /// Profile header
    private let profileHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    /// Statistics container
    private let statsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let reposStatView = StatView(title: "Repositories")
    private let followersStatView = StatView(title: "Followers")
    private let followingStatView = StatView(title: "Following")
    
    /// Profile info
    private let profileInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let viewProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View GitHub Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    private let imageLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    /// Error state
    private let errorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        imageView.image = UIImage(systemName: "exclamationmark.triangle", withConfiguration: configuration)
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    /// Loading state
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()

    private let loadingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading profile data..."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: Initialization
    
    init(user: User) {
        self.viewModel = UserDetailViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        // Show loading state on view load
        showLoadingState()
        
        Task {
            await viewModel.loadUserProfile()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    // MARK: Private Functions
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.username
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileHeaderView)
        contentView.addSubview(profileInfoView)
        contentView.addSubview(viewProfileButton)
        
        // Error state view
        view.addSubview(errorView)
        errorView.addSubview(errorImageView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(retryButton)
        
        // Loading state view
        view.addSubview(loadingView)
        loadingView.addSubview(loadingStackView)
        loadingStackView.addArrangedSubview(loadingIndicator)
        loadingStackView.addArrangedSubview(loadingLabel)
        
        // Profile header
        profileHeaderView.addSubview(avatarImageView)
        profileHeaderView.addSubview(statsContainerView)
        profileHeaderView.addSubview(imageLoadingIndicator)
        
        // Statistics container
        let statsStackView = UIStackView(arrangedSubviews: [reposStatView, followersStatView, followingStatView])
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsContainerView.addSubview(statsStackView)
        
        // Profile information
        profileInfoView.addSubview(nameLabel)
        profileInfoView.addSubview(usernameLabel)
        profileInfoView.addSubview(bioLabel)
        profileInfoView.addSubview(locationLabel)
        
        // Setup constraints for statistics
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            statsStackView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor),
            statsStackView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor),
            statsStackView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor)
        ])
        
        viewProfileButton.addTarget(self, action: #selector(viewProfileButtonTapped), for: .touchUpInside)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        updateUI()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile header view constraints
            profileHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 100),
            
            // Avatar image view constraints
            avatarImageView.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            // Statistics container constraints
            statsContainerView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            statsContainerView.trailingAnchor.constraint(equalTo: profileHeaderView.trailingAnchor),
            statsContainerView.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor),
            statsContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            // Profile info view constraints
            profileInfoView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 15),
            profileInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: profileInfoView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileInfoView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: profileInfoView.trailingAnchor),
            
            // Username label constraints
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            usernameLabel.leadingAnchor.constraint(equalTo: profileInfoView.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: profileInfoView.trailingAnchor),
            
            // Bio label constraints
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: profileInfoView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: profileInfoView.trailingAnchor),
            
            // Location label constraints
            locationLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: profileInfoView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: profileInfoView.trailingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: profileInfoView.bottomAnchor),
            
            // View profile button constraints
            viewProfileButton.topAnchor.constraint(equalTo: profileInfoView.bottomAnchor, constant: 20),
            viewProfileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            viewProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            viewProfileButton.heightAnchor.constraint(equalToConstant: 35),
            viewProfileButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -30),
            
            // Loading indicators constraints
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageLoadingIndicator.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            imageLoadingIndicator.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            // Error view constraints
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Error image constraints
            errorImageView.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: errorView.centerYAnchor, constant: -50),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Error label constraints
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 32),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -32),
            
            // Retry button constraints
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            retryButton.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Loading overlay constraints
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loading stack view constraints
            loadingStackView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingStackView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    private func updateUI() {
        nameLabel.text = viewModel.displayName
        usernameLabel.text = "@\(viewModel.username)"
        
        reposStatView.setValue(viewModel.repositoryCount)
        followersStatView.setValue(viewModel.followersCount)
        followingStatView.setValue(viewModel.followingCount)
        
        if let bio = viewModel.bio, !bio.isEmpty {
            bioLabel.text = bio
            bioLabel.isHidden = false
        } else {
            bioLabel.isHidden = true
        }
        
        if let location = viewModel.location, !location.isEmpty {
            locationLabel.text = "📍 \(location)"
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }
        
        // Load the avatar image
        if let avatarUrlString = viewModel.avatarURL {
            loadAvatarImage(from: avatarUrlString)
        } else {
            setPlaceholderAvatar()
        }
        
        // Enable/disable button
        viewProfileButton.isEnabled = viewModel.profileURL != nil
    }
    
    private func loadAvatarImage(from urlString: String) {
        imageLoadingIndicator.startAnimating()
        setPlaceholderAvatar()
        
        Task { @MainActor in
            let image = await ImageLoadingService.shared.loadImage(from: urlString)
            
            imageLoadingIndicator.stopAnimating()
            
            if let image = image {
                avatarImageView.image = image
                avatarImageView.tintColor = nil
            } else {
                setPlaceholderAvatar()
            }
        }
    }
    
    private func setPlaceholderAvatar() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        let avatarImage = UIImage(systemName: "person.circle", withConfiguration: configuration)
        avatarImageView.image = avatarImage
        avatarImageView.tintColor = .systemGray
    }
    
    @objc private func viewProfileButtonTapped() {
        guard let profileUrl = viewModel.profileURL,
              let url = URL(string: profileUrl) else {
            showErrorAlert(message: "Unable to open user profile URL")
            
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    private func showLoadingState() {
        loadingIndicator.startAnimating()
        loadingView.isHidden = false
        scrollView.isHidden = true
        errorView.isHidden = true
    }

    private func hideLoadingState() {
        loadingIndicator.stopAnimating()
        loadingView.isHidden = true
    }

    private func showContentState() {
        hideLoadingState()
        scrollView.isHidden = false
        errorView.isHidden = true
    }

    private func showErrorState(message: String) {
        hideLoadingState()
        scrollView.isHidden = true
        errorView.isHidden = false
        errorLabel.text = message
    }

    @objc private func retryButtonTapped() {
        Task {
            await viewModel.loadUserProfile()
        }
    }
    
}

// MARK: Delegate Extensions

extension UserDetailViewController: UserDetailViewModelDelegate {
    
    func didLoadUserProfile() {
        showContentState()
        updateUI()
    }
    
    func didStartLoading() {
        showLoadingState()
    }
    
    func didFinishLoading() {
        hideLoadingState()
    }
    
    func didReceiveError(_ error: String) {
        showErrorState(message: error)
    }
}
