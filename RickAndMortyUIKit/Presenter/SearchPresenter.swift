import Foundation

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol? { get set }
    func searchCharacters(name: String)
}

class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    private let networkService: NetworkServiceProtocol
    private var currentTask: DispatchWorkItem?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func searchCharacters(name: String) {
        currentTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.performSearch(name: name)
        }
        currentTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
    
    private func performSearch(name: String) {
        view?.showLoading()
        
        networkService.searchCharacters(name: name) { [weak self] result in
            self?.view?.hideLoading()
            
            switch result {
            case .success(let characters):
                self?.view?.showSearchResults(characters)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
