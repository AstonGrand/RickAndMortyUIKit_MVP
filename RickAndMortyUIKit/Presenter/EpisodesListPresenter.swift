import Foundation

protocol EpisodesListPresenterProtocol: AnyObject {
    var view: EpisodesListViewProtocol? { get set }
    func loadEpisodes()
    func loadMoreEpisodes()
}

class EpisodesListPresenter: EpisodesListPresenterProtocol {
    weak var view: EpisodesListViewProtocol?
    private let networkService: NetworkServiceProtocol
    private var currentPage = 0
    private var isLoading = false
    private var hasMorePages = true
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func loadEpisodes() {
        guard !isLoading else { return }
        isLoading = true
        view?.showLoading()
        
        currentPage = 1
        networkService.fetchEpisodes(page: currentPage) { [weak self] result in
            self?.isLoading = false
            self?.view?.hideLoading()
            
            switch result {
            case .success(let episodes):
                self?.hasMorePages = episodes.count == 20
                self?.view?.showEpisodes(episodes)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func loadMoreEpisodes() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        
        currentPage += 1
        networkService.fetchEpisodes(page: currentPage) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let episodes):
                if episodes.isEmpty {
                    self?.hasMorePages = false
                } else {
                    self?.view?.appendEpisodes(episodes)
                }
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
