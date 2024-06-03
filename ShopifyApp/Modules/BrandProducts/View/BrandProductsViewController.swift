//
//  BrandProductsViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 03/06/2024.
//

import UIKit

class BrandProductsViewController: UIViewController {

    @IBOutlet weak var brandProductsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        brandProductsCollectionView.dataSource=self
        brandProductsCollectionView.delegate=self
        brandProductsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let cellNib=UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        brandProductsCollectionView.register(cellNib, forCellWithReuseIdentifier: "categoriesCell")
    }
    


}
extension BrandProductsViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
         guard let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "productDetailsScreen") as? ProductDetailsViewController else {
             return
         }
       
         navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
extension BrandProductsViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryName.text="Adidas"
        cell.categoryPrice.text="30 LE"

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
