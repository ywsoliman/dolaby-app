//
//  CategoriesViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource=self
        categoriesCollectionView.delegate=self
        categoriesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let cellNib=UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        categoriesCollectionView.register(cellNib, forCellWithReuseIdentifier: "categoriesCell")
    }

}
extension CategoriesViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
         guard let productDetailsViewController = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInfoViewController else {
             return
         }
       
         navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
extension CategoriesViewController:UICollectionViewDataSource{
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
