import UIKit

class MainViewController: UIViewController {
    
    private let characterButton = UIButton(type: .system)
    private let episodeButton = UIButton(type: .system)
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Random Picker"
        
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        configureButton(characterButton, imageName: "person.fill", title: "Random Character", color: .systemBlue, action: #selector(characterTapped))
        configureButton(episodeButton, imageName: "tv.fill", title: "Random Episode", color: .systemGreen, action: #selector(episodeTapped))
        
        stackView.addArrangedSubview(characterButton)
        stackView.addArrangedSubview(episodeButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            characterButton.widthAnchor.constraint(equalToConstant: 200),
            characterButton.heightAnchor.constraint(equalToConstant: 200),
            
            episodeButton.widthAnchor.constraint(equalToConstant: 200),
            episodeButton.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureButton(_ button: UIButton, imageName: String, title: String, color: UIColor, action: Selector) {
        var config = UIButton.Configuration.filled()
        
        // Создаем большую иконку
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)
        config.image = UIImage(systemName: imageName, withConfiguration: largeConfig)
        config.imagePadding = 20
        config.imagePlacement = .top
        config.title = title
        config.baseForegroundColor = .white
        config.baseBackgroundColor = color
        config.cornerStyle = .large
        config.buttonSize = .large
        
        button.configuration = config
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func characterTapped() {
        let characterVC = CharacterViewController()
        navigationController?.pushViewController(characterVC, animated: true)
    }
    
    @objc private func episodeTapped() {
        let episodeVC = EpisodeViewController()
        navigationController?.pushViewController(episodeVC, animated: true)
    }
}
