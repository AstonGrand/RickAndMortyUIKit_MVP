import Foundation

protocol EpisodePresenterProtocol: AnyObject {
    var view: EpisodeViewProtocol? { get set }
    func loadEpisode()
}

class EpisodePresenter: EpisodePresenterProtocol {
    weak var view: EpisodeViewProtocol?
    private let networkService: NetworkServiceProtocol
    private let episodeID: Int?
    
    init(episodeID: Int? = nil, networkService: NetworkServiceProtocol = NetworkService()) {
        self.episodeID = episodeID
        self.networkService = networkService
    }
    
    func loadEpisode() {
        view?.showLoading()
        
        let completion: (Result<RMEpisodeModel, NetworkError>) -> Void = { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let episode):
                self?.view?.showEpisode(episode)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
        
        if let id = episodeID {
            networkService.fetchEpisode(id: id, completion: completion)
        } else {
            networkService.fetchRandomEpisode(completion: completion)
        }
    }
}

