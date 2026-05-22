import UIKit

protocol EpisodeViewProtocol: AnyObject {
    func showEpisode(_ episode: RMEpisodeModel)
    func showError(_ error: String)
    func showLoading()
    func hideLoading()
}

class EpisodeViewController: UIViewController, EpisodeViewProtocol {
    private let presenter: EpisodePresenterProtocol
    
    private let nameLabel = UILabel()
    private let episodeLabel = UILabel()
    private let airDateLabel = UILabel()
    private let charactersCountLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    init(episodeID: Int? = nil) {
        self.presenter = EpisodePresenter(episodeID: episodeID)
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadEpisode()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Episode"
        
        // Настройка элементов (аналогично CharacterViewController)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [nameLabel, episodeLabel, airDateLabel, charactersCountLabel, loadingIndicator].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.numberOfLines = 0
        episodeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        airDateLabel.font = .systemFont(ofSize: 16)
        charactersCountLabel.font = .systemFont(ofSize: 16)
        
        loadingIndicator.hidesWhenStopped = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(episodeLabel)
        contentView.addSubview(airDateLabel)
        contentView.addSubview(charactersCountLabel)
        contentView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            episodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            episodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            episodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            airDateLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 8),
            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            charactersCountLabel.topAnchor.constraint(equalTo: airDateLabel.bottomAnchor, constant: 8),
            charactersCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            charactersCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            charactersCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func showEpisode(_ episode: RMEpisodeModel) {
        nameLabel.text = episode.name
        episodeLabel.text = "Episode: \(episode.episode)"
        airDateLabel.text = "Air Date: \(episode.airDate)"
        charactersCountLabel.text = "Characters count: \(episode.characters.count)"
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
}

