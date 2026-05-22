import Foundation

protocol CharactersListPresenterProtocol: AnyObject {
    var view: CharactersListViewProtocol? { get set }
    func loadCharacters()
    func loadMoreCharacters()
}

class CharactersListPresenter: CharactersListPresenterProtocol {
    weak var view: CharactersListViewProtocol?
    private let networkService: NetworkServiceProtocol
    private var currentPage = 0
    private var isLoading = false
    private var hasMorePages = true
    private var allCharacters: [RMCharacterModel] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func loadCharacters() {
        guard !isLoading else { return }
        isLoading = true
        view?.showLoading()
        
        currentPage = 1
        networkService.fetchCharacters(page: currentPage) { [weak self] result in
            self?.isLoading = false
            self?.view?.hideLoading()
            
            switch result {
            case .success(let characters):
                self?.allCharacters = characters
                self?.hasMorePages = characters.count == 20
                self?.view?.showCharacters(characters)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func loadMoreCharacters() {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        view?.showLoadingMore()
        
        currentPage += 1
        networkService.fetchCharacters(page: currentPage) { [weak self] result in
            self?.isLoading = false
            self?.view?.hideLoadingMore()
            
            switch result {
            case .success(let characters):
                if characters.isEmpty {
                    self?.hasMorePages = false
                } else {
                    self?.allCharacters.append(contentsOf: characters)
                    self?.view?.appendCharacters(characters)
                }
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
