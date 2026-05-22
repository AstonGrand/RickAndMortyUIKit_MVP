import UIKit

class EpisodeCell: UITableViewCell {
    static let identifier = "EpisodeCell"
    
    private let nameLabel = UILabel()
    private let episodeLabel = UILabel()
    private let airDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        episodeLabel.font = .systemFont(ofSize: 14)
        episodeLabel.textColor = .secondaryLabel
        airDateLabel.font = .systemFont(ofSize: 14)
        airDateLabel.textColor = .secondaryLabel
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeLabel.translatesAutoresizingMaskIntoConstraints = false
        airDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(episodeLabel)
        contentView.addSubview(airDateLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            episodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            episodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            airDateLabel.topAnchor.constraint(equalTo: episodeLabel.topAnchor),
            airDateLabel.leadingAnchor.constraint(equalTo: episodeLabel.trailingAnchor, constant: 12),
            airDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            airDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with episode: RMEpisodeModel) {
        nameLabel.text = episode.name
        episodeLabel.text = episode.episode
        airDateLabel.text = episode.airDate
    }
}
