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
    let indicator = UIActivityIndicatorView(style: .large)
    var homeViewModel:HomeViewModelProtocol?
    var brands=[Brand]()
    override func viewDidLoad() {
        super.viewDidLoad()
        brandsCollectionView.delegate=self
        brandsCollectionView.dataSource=self
        adsImage.clipsToBounds=true
        adsImage.layer.cornerRadius=15
        brandsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        indicator.startAnimating()
        homeViewModel=HomeViewModel(networkService: NetworkService())
        homeViewModel?.fetchBrands()
        homeViewModel?.bindBrandsToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.brands=self?.homeViewModel?.getBrands() ?? []
                self?.indicator.stopAnimating()
                self?.brandsCollectionView.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
        
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
        homeViewModel?.getBrandsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCollectionViewCell
        cell.brandName.text="Adidas"
        cell.brandImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.brandImage.layer.borderWidth=1
        cell.brandImage.layer.cornerRadius=20
        
        cell.brandName.text=brands[indexPath.item].title
        downloadImage(from: brands[indexPath.item].image?.src ?? "") { image in
           cell.brandImage.image = image
        }
        return cell
    }
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                print("Error downloading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}
extension HomeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.425
        let height=width

         return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
   

}

