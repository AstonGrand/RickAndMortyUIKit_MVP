import UIKit

protocol CharactersListViewProtocol: AnyObject {
    func showCharacters(_ characters: [RMCharacterModel])
    func appendCharacters(_ characters: [RMCharacterModel])
    func showError(_ error: String)
    func showLoading()
    func hideLoading()
    func showLoadingMore()
    func hideLoadingMore()
}

class CharactersListViewController: UIViewController, CharactersListViewProtocol {
    private let presenter: CharactersListPresenterProtocol
    private var collectionView: UICollectionView!
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let footerLoadingIndicator = UIActivityIndicatorView(style: .medium)
    private var characters: [RMCharacterModel] = []
    private var isLoadingMore = false
    
    init() {
        self.presenter = CharactersListPresenter()
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadCharacters()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let width = (view.bounds.width - spacing * 3) / 2
        layout.itemSize = CGSize(width: width, height: width + 50)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        footerLoadingIndicator.hidesWhenStopped = true
        footerLoadingIndicator.color = .gray
        
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showCharacters(_ characters: [RMCharacterModel]) {
        self.characters = characters
        collectionView.reloadData()
    }
    
    func appendCharacters(_ characters: [RMCharacterModel]) {
        self.characters.append(contentsOf: characters)
        collectionView.reloadData()
        isLoadingMore = false
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
        isLoadingMore = true
        footerLoadingIndicator.startAnimating()
        
        // Добавляем footer view как supplementary view
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        // Или можно использовать custom footer view
        let footerRect = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
        let footerView = UIView(frame: footerRect)
        footerLoadingIndicator.center = footerView.center
        footerView.addSubview(footerLoadingIndicator)
        collectionView.addSubview(footerView)
        
        // Анимация появления
        UIView.animate(withDuration: 0.3) {
            footerView.frame.origin.y = self.collectionView.contentSize.height
        }
    }
    
    func hideLoadingMore() {
        isLoadingMore = false
        footerLoadingIndicator.stopAnimating()
        collectionView.contentInset = .zero
        
        // Удаляем все footer views
        collectionView.subviews.forEach { view in
            //if view is UIView && view != collectionView {
            if view != collectionView {
                view.removeFromSuperview()
            }
        }
    }
}

extension CharactersListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as! CharacterCell
        cell.configure(with: characters[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characterVC = CharacterViewController(characterID: characters[indexPath.item].id)
        navigationController?.pushViewController(characterVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 && !isLoadingMore {
            presenter.loadMoreCharacters()
        }
    }
}
