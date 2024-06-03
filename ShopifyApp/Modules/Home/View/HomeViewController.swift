//
//  HomeViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 28/05/2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var adsImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        brandsCollectionView.delegate=self
        brandsCollectionView.dataSource=self
        adsImage.clipsToBounds=true
        adsImage.layer.cornerRadius=15
        brandsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    
    }

}
extension HomeViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
         guard let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "brandProductsScreen") as? BrandProductsViewController else {
             return
         }
       
         navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
extension HomeViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCollectionViewCell
        cell.brandName.text="Adidas"
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=1
        cell.layer.cornerRadius=20
        return cell
    }
    
    
}
extension HomeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.43
        let height=width

         return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
   

}

