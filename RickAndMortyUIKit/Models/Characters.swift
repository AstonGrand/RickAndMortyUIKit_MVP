public struct RMCharacterModel: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let origin: RMCharacterOriginModel
    public let location: RMCharacterLocationModel
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}

public struct RMCharacterOriginModel: Codable {
    public let name: String
    public let url: String
}

public struct RMCharacterLocationModel: Codable {
    public let name: String
    public let url: String
}

struct RMCharacterInfoModel: Codable {
    let info: Info
    let results: [RMCharacterModel]
}
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
