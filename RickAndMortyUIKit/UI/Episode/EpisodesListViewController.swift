import UIKit

protocol EpisodesListViewProtocol: AnyObject {
    func showEpisodes(_ episodes: [RMEpisodeModel])
    func appendEpisodes(_ episodes: [RMEpisodeModel])
    func showError(_ error: String)
    func showLoading()
    func hideLoading()
    func showLoadingMore()
    func hideLoadingMore()
}

class EpisodesListViewController: UIViewController, EpisodesListViewProtocol {
    private let presenter: EpisodesListPresenterProtocol
    private var tableView: UITableView!
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private var episodes: [RMEpisodeModel] = []
    
    init() {
        self.presenter = EpisodesListPresenter()
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadEpisodes()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Episodes"
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showEpisodes(_ episodes: [RMEpisodeModel]) {
        self.episodes = episodes
        tableView.reloadData()
    }
    
    func appendEpisodes(_ episodes: [RMEpisodeModel]) {
        self.episodes.append(contentsOf: episodes)
        tableView.reloadData()
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
    
    func showLoadingMore() {
        // Можно добавить footer
    }
    
    func hideLoadingMore() {}
}

extension EpisodesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier, for: indexPath) as! EpisodeCell
        cell.configure(with: episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let episodeVC = EpisodeViewController(episodeID: episodes[indexPath.row].id)
        navigationController?.pushViewController(episodeVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 {
            presenter.loadMoreEpisodes()
        }
    }
}
