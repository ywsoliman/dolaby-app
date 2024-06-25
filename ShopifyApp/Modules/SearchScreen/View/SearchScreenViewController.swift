//
//  SearchScreenViewController.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 14/06/2024.
//

import UIKit
import Combine
class SearchScreenViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let viewModel:SearchScreenViewModel = SearchScreenViewModel(networkService: NetworkService.shared)
    let indicator = UIActivityIndicatorView(style: .large)
    var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    private let favViewModel:FavouriteViewModel = FavouriteViewModel(favSerivce: FavoritesManager.shared)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let cellNib=UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "categoriesCell")
        indicator.startAnimating()
        favViewModel.fetchFavouriteItems()
        viewModel.fetchProducts()
        viewModel.bindProductsToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
        $searchText.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] debouncedSearchText in
                print(debouncedSearchText)
                self?.viewModel.filterBySearchText(text:debouncedSearchText)
            }
            .store(in: &cancellables)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        favViewModel.updateFavItems()
        collectionView.reloadData()
        print("View Will appear and reload")
    }
}
extension SearchScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}

extension SearchScreenViewController:UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
        guard let productDetailsViewController = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInfoViewController else {
            return
        }
        productDetailsViewController.productID = viewModel.filteredProducts[indexPath.item].id
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isEmpty =  viewModel.filteredProducts.count == 0
        collectionView.backgroundView = isEmpty ? getBackgroundView() : nil
        return viewModel.filteredProducts.count
    }
    func getBackgroundView() -> UIView {
        let backgroundView = UIView(frame: collectionView.bounds)
        let imageView = UIImageView(frame: backgroundView.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "noProductsFound")
        backgroundView.addSubview(imageView)
        return backgroundView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.delegate = self
        cell.cellIndex = indexPath.item
        cell.updateFavBtnImage(isFav: favViewModel.isFavoriteItem(withId: viewModel.filteredProducts[indexPath.item].id))
        let titleComponents = viewModel.filteredProducts[indexPath.item].title.split(separator: " | ")
        let categoryName = String(titleComponents.last ?? "")
        cell.categoryName.text = categoryName
        cell.categoryPrice.text = (viewModel.filteredProducts[indexPath.item].variants[0].price).priceFormatter()
        cell.clipsToBounds=true
        cell.layer.cornerRadius=20
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=0.7
        let url=URL(string: viewModel.filteredProducts[indexPath.item].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg")
        guard let imageUrl=url else{
            print("Error loading image: ",APIError.invalidURL)
            return cell
        }
        cell.categoryImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell
    }
}
extension SearchScreenViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.44
        let height=width*1.2
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
extension SearchScreenViewController:FavItemDelegate{
    func notAuthenticated() {
        showAlert(message: "You need to login first.") {
            let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
            let loginVC =
            
            storyboard.instantiateViewController(identifier: "loginNav") as UINavigationController
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .flipHorizontal
            self.present(loginVC, animated: true)
            self.navigationController?.viewControllers = []
            
        }
    }
    
    func deleteFavItem(itemIndex: Int) {
        showAlert(message: "Are you sure you want to remove this item from your favorites?"){ [weak self] in
            self?.favViewModel.deleteFavouriteItem(itemId: self?.viewModel.filteredProducts[itemIndex].id ?? 0)
            let indexPath = IndexPath(item: itemIndex, section: 0)
            if let cell = self?.collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
                cell.updateFavBtnImage(isFav: false)
            }
        }
    }
    
    func saveFavItem(itemIndex: Int) {
        favViewModel.addToFav(favItem: FavoriteItem(id: viewModel.filteredProducts[itemIndex].id, itemName: viewModel.filteredProducts[itemIndex].title, imageURL: viewModel.filteredProducts[itemIndex].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg"))
    }
    func showAlert(message: String, okHandler: @escaping () -> Void) {
            let alert = UIAlertController(title: "Confirmation", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                okHandler()
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
        }
    
}

