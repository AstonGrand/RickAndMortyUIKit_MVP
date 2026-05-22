import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // Главный экран (случайные персонаж и эпизод)
        let mainVC = MainViewController()
        let mainNav = UINavigationController(rootViewController: mainVC)
        mainNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        // Список персонажей
        let charactersVC = CharactersListViewController()
        let charactersNav = UINavigationController(rootViewController: charactersVC)
        charactersNav.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.3.fill"), tag: 1)
        
        // Поиск
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        // Список эпизодов
        let episodesVC = EpisodesListViewController()
        let episodesNav = UINavigationController(rootViewController: episodesVC)
        episodesNav.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv.fill"), tag: 3)
        
        viewControllers = [mainNav, charactersNav, searchNav, episodesNav]
        
        // Настройка внешнего вида таббара
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }
}
