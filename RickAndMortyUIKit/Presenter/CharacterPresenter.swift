import Foundation

protocol CharacterPresenterProtocol: AnyObject {
    var view: CharacterViewProtocol? { get set }
    func loadCharacter()
}

class CharacterPresenter: CharacterPresenterProtocol {
    weak var view: CharacterViewProtocol?
    private let networkService: NetworkServiceProtocol
    private let characterID: Int?
    
    init(characterID: Int? = nil, networkService: NetworkServiceProtocol = NetworkService()) {
        self.characterID = characterID
        self.networkService = networkService
    }
    
    func loadCharacter() {
        view?.showLoading()
        
        let completion: (Result<RMCharacterModel, NetworkError>) -> Void = { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let character):
                self?.view?.showCharacter(character)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
        
        if let id = characterID {
            networkService.fetchCharacter(id: id, completion: completion)
        } else {
            networkService.fetchRandomCharacter(completion: completion)
        }
    }
}
