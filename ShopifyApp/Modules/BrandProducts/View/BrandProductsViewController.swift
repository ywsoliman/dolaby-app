//
//  BrandProductsViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 03/06/2024.
//

import UIKit

class BrandProductsViewController: UIViewController {
    @IBOutlet weak var priceFilterStack: UIStackView!
    
    @IBOutlet weak var brandProductsCollectionView: UICollectionView!
    @IBOutlet weak var priceForFilter: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    let indicator = UIActivityIndicatorView(style: .large)
    var brandProductsViewModel:BrandProductsViewModelProtocol?
    private var favViewModel:FavouriteViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        priceSlider.maximumValue=500
        priceSlider.minimumValue=1
        priceSlider.value=priceSlider.maximumValue
        priceForFilter.text=String(priceSlider.value)+" LE"
        if brandProductsViewModel==nil{
            print("brandProductsViewModel==nil")
        }
        priceFilterStack.isHidden=true
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {[weak self] in
            self?.priceFilterStack.isHidden.toggle()
        }
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
        let formattedValue = String(format: "%.2f", (sender as! UISlider).value)
        priceForFilter.text = "\(formattedValue) LE"
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
        let sliderFormattedValue = Double(String(format: "%.2f", priceSlider.value)) ?? 0
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
        guard let productDetailsViewController = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInfoViewController else {
            return
        }
        productDetailsViewController.productID = brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[indexPath.item].id
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
extension BrandProductsViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sliderFormattedValue = Double(String(format: "%.2f", priceSlider.value)) ?? 0
        return brandProductsViewModel?.getProductsCount(withPrice: sliderFormattedValue) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sliderFormattedValue = Double(String(format: "%.2f", priceSlider.value)) ?? 0
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.delegate = self
        cell.cellIndex = indexPath.item
        cell.categoryPrice.text="\((brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[indexPath.item].variants[0].price) ?? "0.0") LE"
        cell.updateFavBtnImage(isFav: favViewModel.isFavoriteItem(withId: brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[indexPath.item].id ?? 0))
        let titleComponents = brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[indexPath.item].title.split(separator: " | ")
        let categoryName = String(titleComponents?.last ?? "")
        cell.categoryName.text = categoryName
        cell.clipsToBounds=true
        cell.layer.cornerRadius=20
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=0.7
        let url=URL(string: brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[indexPath.item].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg")
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
        let sliderFormattedValue = Double(String(format: "%.2f", priceSlider.value)) ?? 0
        let id = brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[itemIndex].id
        favViewModel.deleteFavouriteItem(itemId: id ?? 0)
    }
    
    func saveFavItem(itemIndex: Int) {
        let sliderFormattedValue = Double(String(format: "%.2f", priceSlider.value)) ?? 0
        favViewModel.addToFav(favItem: FavoriteItem(id: brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[itemIndex].id ?? 0, itemName: brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[itemIndex].title ?? " | ", imageURL: brandProductsViewModel?.getProducts(withPrice: sliderFormattedValue)[itemIndex].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg"))
    }
    func showAlert(message: String, okHandler: @escaping () -> Void) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                okHandler()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
        }
    
}

