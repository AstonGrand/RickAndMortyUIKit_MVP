import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
}

protocol NetworkServiceProtocol {
    func fetchCharacter(id: Int, completion: @escaping (Result<RMCharacterModel, NetworkError>) -> Void)
    func fetchEpisode(id: Int, completion: @escaping (Result<RMEpisodeModel, NetworkError>) -> Void)
    func fetchRandomCharacter(completion: @escaping (Result<RMCharacterModel, NetworkError>) -> Void)
    func fetchRandomEpisode(completion: @escaping (Result<RMEpisodeModel, NetworkError>) -> Void)
    func fetchCharacters(page: Int, completion: @escaping (Result<[RMCharacterModel], NetworkError>) -> Void)
    func fetchEpisodes(page: Int, completion: @escaping (Result<[RMEpisodeModel], NetworkError>) -> Void)
    func searchCharacters(name: String, completion: @escaping (Result<[RMCharacterModel], NetworkError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://rickandmortyapi.com/api"
    private let cache = NSCache<NSString, NSData>()
    private let maxCharacterID = 826
    private let maxEpisodeID = 51
    
    // MARK: - Single Item Fetching
    func fetchCharacter(id: Int, completion: @escaping (Result<RMCharacterModel, NetworkError>) -> Void) {
        fetch(endpoint: "character", id: id, completion: completion)
    }
    
    func fetchEpisode(id: Int, completion: @escaping (Result<RMEpisodeModel, NetworkError>) -> Void) {
        fetch(endpoint: "episode", id: id, completion: completion)
    }
    
    func fetchRandomCharacter(completion: @escaping (Result<RMCharacterModel, NetworkError>) -> Void) {
        let randomID = Int.random(in: 1...maxCharacterID)
        fetchCharacter(id: randomID, completion: completion)
    }
    
    func fetchRandomEpisode(completion: @escaping (Result<RMEpisodeModel, NetworkError>) -> Void) {
        let randomID = Int.random(in: 1...maxEpisodeID)
        fetchEpisode(id: randomID, completion: completion)
    }
    
    // MARK: - Lists Fetching
    func fetchCharacters(page: Int, completion: @escaping (Result<[RMCharacterModel], NetworkError>) -> Void) {
        fetchList(endpoint: "character", page: page, completion: completion)
    }
    
    func fetchEpisodes(page: Int, completion: @escaping (Result<[RMEpisodeModel], NetworkError>) -> Void) {
        fetchList(endpoint: "episode", page: page, completion: completion)
    }
    
    // MARK: - Search
    func searchCharacters(name: String, completion: @escaping (Result<[RMCharacterModel], NetworkError>) -> Void) {
        let cacheKey = "search_\(name)" as NSString
        
        if let cachedData = cache.object(forKey: cacheKey) {
            do {
                let decoded = try JSONDecoder().decode([RMCharacterModel].self, from: cachedData as Data)
                DispatchQueue.main.async { completion(.success(decoded)) }
                return
            } catch {
                print("Cache decode error: \(error)")
            }
        }
        
        let query = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "\(baseURL)/character/?name=\(query)") else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(.networkError(error))) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            do {
                let wrapper = try JSONDecoder().decode(APIWrapper<RMCharacterModel>.self, from: data)
                self?.cache.setObject(data as NSData, forKey: cacheKey)
                DispatchQueue.main.async { completion(.success(wrapper.results)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }.resume()
    }
    
    // MARK: - Private Helpers
    private func fetch<T: Codable>(endpoint: String, id: Int, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let cacheKey = "\(endpoint)_\(id)" as NSString
        
        if let cachedData = cache.object(forKey: cacheKey) {
            do {
                let decoded = try JSONDecoder().decode(T.self, from: cachedData as Data)
                DispatchQueue.main.async { completion(.success(decoded)) }
                return
            } catch {
                print("Cache decode error: \(error)")
            }
        }
        
        guard let url = URL(string: "\(baseURL)/\(endpoint)/\(id)") else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(.networkError(error))) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                self?.cache.setObject(data as NSData, forKey: cacheKey)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }.resume()
    }
    
    private func fetchList<T: Codable>(endpoint: String, page: Int, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let cacheKey = "\(endpoint)_list_page_\(page)" as NSString
        
        if let cachedData = cache.object(forKey: cacheKey) {
            do {
                let decoded = try JSONDecoder().decode([T].self, from: cachedData as Data)
                DispatchQueue.main.async { completion(.success(decoded)) }
                return
            } catch {
                print("Cache decode error: \(error)")
            }
        }
        
        guard let url = URL(string: "\(baseURL)/\(endpoint)?page=\(page)") else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(.networkError(error))) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            do {
                let wrapper = try JSONDecoder().decode(APIWrapper<T>.self, from: data)
                let resultsData = try JSONEncoder().encode(wrapper.results)
                self?.cache.setObject(resultsData as NSData, forKey: cacheKey)
                DispatchQueue.main.async { completion(.success(wrapper.results)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }.resume()
    }
}

// MARK: - API Wrapper
struct APIWrapper<T: Codable>: nonisolated Codable {
    let info: Info
    let results: [T]
}

 struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
