//
//  CategoriesViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    let indicator = UIActivityIndicatorView(style: .large)
    var categoriesViewModel:CategoriesViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource=self
        categoriesCollectionView.delegate=self
        categoriesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let cellNib=UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        categoriesCollectionView.register(cellNib, forCellWithReuseIdentifier: "categoriesCell")
        indicator.startAnimating()
        categoriesViewModel=CategoriesViewModel(networkService: NetworkService.shared)
        categoriesViewModel?.fetchProducts()
        categoriesViewModel?.bindProductsToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.categoriesCollectionView.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
    }

}
extension CategoriesViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
         guard let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController else {
             return
         }
       
         navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
extension CategoriesViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         categoriesViewModel?.getProductsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CategoriesCollectionViewCell

        let titleComponents = categoriesViewModel?.getProducts()[indexPath.item].title.split(separator: " | ")
        let categoryName = String(titleComponents?.last ?? "")
        cell.categoryName.text = categoryName
        cell.categoryPrice.text="\( (categoriesViewModel?.getProducts()[indexPath.item].variants[0].price) ?? "0.0") LE"
        cell.clipsToBounds=true
        cell.layer.cornerRadius=20
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=0.7
        let url=URL(string: categoriesViewModel?.getProducts()[indexPath.item].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg")
        guard let imageUrl=url else{
            print("Error loading image: ",APIError.invalidURL)
            return cell
        }
        cell.categoryImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell    }
    
}
extension CategoriesViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.44
        let height=width*1.2

         return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
   

}
