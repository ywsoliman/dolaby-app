//
//  BrandProductsViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 03/06/2024.
//

import UIKit
import Combine
class BrandProductsViewController: UIViewController {
    @IBOutlet weak var priceFilterStack: UIStackView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var brandProductsCollectionView: UICollectionView!
    @IBOutlet weak var priceForFilter: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    let indicator = UIActivityIndicatorView(style: .large)
    var brandProductsViewModel:BrandProductsViewModel?
    private var favViewModel:FavouriteViewModel!
    @Published var searchText: String = ""
    var cancellables = Set<AnyCancellable>()
    var sliderFormattedValue:Double = 5000.0
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        favViewModel = FavouriteViewModel(favSerivce: FavoritesManager.shared)
        brandProductsCollectionView.dataSource=self
        brandProductsCollectionView.delegate=self
        brandProductsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let cellNib=UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        brandProductsCollectionView.register(cellNib, forCellWithReuseIdentifier: "categoriesCell")
        
        indicator.startAnimating()
        brandProductsViewModel?.fetchProducts()
        brandProductsViewModel?.bindProductsToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.brandProductsCollectionView.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
        priceSlider.maximumValue=300
        priceSlider.minimumValue=1
        priceSlider.value=priceSlider.maximumValue
        priceForFilter.text=String(priceSlider.value).priceFormatter()
        $searchText.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] debouncedSearchText in
                self?.sliderFormattedValue = Double(String(format: "%.2f", self?.priceSlider.value ?? 5000)) ?? 0
                print(debouncedSearchText)
                self?.brandProductsViewModel?.filterProducts(withPrice: self?.sliderFormattedValue ?? 5000.0, searchText: debouncedSearchText)
                self?.brandProductsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        if brandProductsViewModel==nil{
            print("brandProductsViewModel==nil")
        }
        priceFilterStack.isHidden=true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {[weak self] in
            self?.priceFilterStack.isHidden.toggle()
        }
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
        let formattedValue = String(format: "%.2f", (sender as! UISlider).value)
        priceForFilter.text = formattedValue.priceFormatter()
        sliderFormattedValue = Double(formattedValue) ?? 0.0
        brandProductsViewModel?.filterProducts(withPrice: sliderFormattedValue, searchText: searchText)
        brandProductsCollectionView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        favViewModel.updateFavItems()
        brandProductsCollectionView.reloadData()
    }

}
extension BrandProductsViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
        guard let productDetailsViewController = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInfoViewController else {
            return
        }
        productDetailsViewController.productID = brandProductsViewModel?.filteredProducts[indexPath.item].id
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
extension BrandProductsViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandProductsViewModel?.filteredProducts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.delegate = self
        cell.cellIndex = indexPath.item
        cell.categoryPrice.text=(brandProductsViewModel?.filteredProducts[indexPath.item].variants[0].price ?? "0").priceFormatter()
        
        cell.updateFavBtnImage(isFav: favViewModel.isFavoriteItem(withId: brandProductsViewModel?.filteredProducts[indexPath.item].id ?? 0))
        let titleComponents = brandProductsViewModel?.filteredProducts[indexPath.item].title.split(separator: " | ")
        let categoryName = String(titleComponents?.last ?? "")
        cell.categoryName.text = categoryName
        cell.clipsToBounds=true
        cell.layer.cornerRadius=20
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=0.7
        let url=URL(string: brandProductsViewModel?.filteredProducts[indexPath.item].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg")
        guard let imageUrl=url else{
            print("Error loading image: ",APIError.invalidURL)
            return cell
        }
        cell.categoryImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell
    }
}
extension BrandProductsViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.44
        let height=width*1.2

         return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
   

}

extension BrandProductsViewController:FavItemDelegate{
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
            let id = self?.brandProductsViewModel?.filteredProducts[itemIndex].id ?? 0
            self?.favViewModel.deleteFavouriteItem(itemId: id)
            self?.favViewModel.updateFavItems()
            let indexPath = IndexPath(item: itemIndex, section: 0)
                    if let cell = self?.brandProductsCollectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
                        cell.updateFavBtnImage(isFav: false)
                    }
            print("Data reloaded Brand products")
        }
        
    }
    
    func saveFavItem(itemIndex: Int) {
        favViewModel.addToFav(favItem: FavoriteItem(id: brandProductsViewModel?.filteredProducts[itemIndex].id ?? 0, itemName: brandProductsViewModel?.filteredProducts[itemIndex].title ?? " | ", imageURL: brandProductsViewModel?.filteredProducts[itemIndex].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg"))
    }
    func showAlert(message: String, okHandler: @escaping () -> Void) {
            let alert = UIAlertController(title: "Confirmation", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                okHandler()
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){[weak self] _ in
            self?.brandProductsCollectionView.reloadData()
        }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    
}

extension BrandProductsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}
