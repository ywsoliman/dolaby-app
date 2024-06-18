//
//  FavouriteScreenViewController.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 15/06/2024.
//

import UIKit

class FavouriteScreenViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel:FavouriteViewModel!
    let indicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavouriteViewModel(favSerivce: FavoritesManager.shared)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let cellNib=UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "categoriesCell")
        indicator.startAnimating()
        viewModel.bindToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
        viewModel.fetchFavouriteItems()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.updateFavItems()
        collectionView.reloadData()
    }

}

extension FavouriteScreenViewController:UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
         guard let productDetailsViewController = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInfoViewController else {
             return
         }
        productDetailsViewController.productID = viewModel.favouriteItems[indexPath.item].id
         navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isEmpty =  viewModel.favouriteItems.count == 0
        collectionView.backgroundView = isEmpty ? getBackgroundView() : nil
        return viewModel.favouriteItems.count
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
        let titleComponents = viewModel.favouriteItems[indexPath.item].itemName.split(separator: " | ")
        let categoryName = String(titleComponents.last ?? "")
        cell.categoryName.text = categoryName
        cell.updateFavBtnImage(isFav: true)
        cell.categoryPrice.text="      "
        cell.clipsToBounds=true
        cell.layer.cornerRadius=20
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=0.7
        let url=URL(string: viewModel.favouriteItems[indexPath.item].imageURL)
        guard let imageUrl=url else{
            print("Error loading image: ",APIError.invalidURL)
            return cell
        }
        cell.categoryImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell
    }
}
extension FavouriteScreenViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.44
        let height=width*1.2

        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
   
}

extension FavouriteScreenViewController:FavItemDelegate{
    func notAuthenticated() {
        showAlert(message: "You need to login first.") {
            let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
            guard let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController else {
                        return
                    }
                loginVC.modalPresentationStyle = .fullScreen
                loginVC.modalTransitionStyle = .flipHorizontal
                self.present(loginVC, animated: true)
                self.navigationController?.viewControllers = []
                    }
    }
    
    func deleteFavItem(itemIndex: Int) {
        print(" deletening Item index = \(itemIndex)")
        showAlert(message: "Are you sure you want to remove this item from your favorites?"){ [weak self] in
            self?.viewModel.deleteFavouriteItem(itemId:  self?.viewModel.favouriteItems[itemIndex].id ?? 0)
            self?.collectionView.reloadData()
        }
    }
    
    func saveFavItem(itemIndex: Int) {
        print("deletening Item index 2 = \(itemIndex)")
        showAlert(message: "Are you sure you want to remove this item from your favorites?"){ [weak self] in
            self?.viewModel.deleteFavouriteItem(itemId:  self?.viewModel.favouriteItems[itemIndex].id ?? 0)
            self?.collectionView.reloadData()
        }
        
    }
    
}
extension FavouriteScreenViewController{
    func showAlert(message: String, okHandler: @escaping () -> Void) {
            let alert = UIAlertController(title: "Confirmation", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                okHandler()
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){[weak self] _ in
            self?.collectionView.reloadData()
        }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
        }
}
    
