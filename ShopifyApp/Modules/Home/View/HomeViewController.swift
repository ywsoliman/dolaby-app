//
//  HomeViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 28/05/2024.
//

import UIKit

enum HomeSections {
    case discounts
    case brands
    
    var title: String {
        switch self {
        case .discounts:
            return "Discounts"
        case .brands:
            return "Brands"
        }
    }
}

protocol DiscountPageControlDelegate {
    func configure(_ page: Int)
}

class HomeViewController: UIViewController {
    
    let indicator = UIActivityIndicatorView(style: .large)
    var homeViewModel: HomeViewModelProtocol?
    private let discountWithIndex = [0: "discount-1", 1: "discount-2", 2: "discount-3"]
    private let discountImages = ["discount-1", "discount-2", "discount-3"]
    private var imageWithCoupon: [String: String] = [:]
    private let homeSections: [HomeSections] = [.discounts, .brands]
    private var discountPageControlView: DiscountPageControlReusableView?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        
        indicator.startAnimating()
        homeViewModel = HomeViewModel(service: NetworkService.shared, currencyService: CurrencyService.shared)
        favViewModel.fetchFavouriteItems()
        homeViewModel?.loadUser()
        homeViewModel?.fetchBrands()
        homeViewModel?.bindBrandsToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
        
        setupDiscountSection()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnviroment in
            guard let self = self else { return nil }
            let section = homeSections[sectionIndex]
            switch section {
            case .discounts:
                return createDiscountsCollectionView()
            case .brands:
                return createBrandsCollectionView()
            }
        }
    }
    
    private func createDiscountsCollectionView() -> NSCollectionLayoutSection {
        
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 16)
        
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .absolute(200), item: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [supplementaryHeaderItem(), supplemntaryFooterItem()]
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, _, _) in
            if let indexPath = visibleItems.last?.indexPath {
                self?.discountPageControlView?.configure(indexPath.row)
            }
        }
        return section
        
    }
    
    private func createBrandsCollectionView() -> NSCollectionLayoutSection {
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 16)
        
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(0.5), height: .fractionalHeight(0.3), item: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        return section
        
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(60)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    private func supplemntaryFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
    }
    
    func setupDiscountSection() {
        homeViewModel?.getDiscountCodes { [weak self] in
            self?.constructImageCouponDictionary()
        }
    }
    
    func constructImageCouponDictionary() {
        imageWithCoupon["discount-1"] = Discounts.discounts[0].title
        imageWithCoupon["discount-2"] = Discounts.discounts[1].title
        imageWithCoupon["discount-3"] = Discounts.discounts[2].title
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return homeSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch homeSections[section] {
        case .discounts:
            return 3
        case .brands:
            return homeViewModel?.getBrandsCount() ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch homeSections[indexPath.section] {
        case .discounts:
            return configureDiscountCell(collectionView, indexPath)
        case .brands:
            return configureBrandCell(collectionView, indexPath)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch homeSections[indexPath.section] {
        case .discounts:
            copiedCouponAlert(indexPath)
        case .brands:
            navigateToBrandProducts(indexPath)
        }
        
    }
    
    private func copiedCouponAlert(_ indexPath: IndexPath) {
        UIPasteboard.general.string = imageWithCoupon[discountWithIndex[indexPath.row] ?? "N/A"]
        alertWithDuration(message: "Copoun copied successfully!🎉 \(UIPasteboard.general.string ?? "N/A")", viewController: self)
    }
    
    private func navigateToBrandProducts(_ indexPath: IndexPath) {
        guard let brandProductsViewController = storyboard?.instantiateViewController(withIdentifier: "brandProductsScreen") as? BrandProductsViewController else {
            return
        }
        
        let brandProductsViewModel=BrandProductsViewModel(networkService: NetworkService.shared)
        brandProductsViewModel.brandId=homeViewModel?.getBrands()[indexPath.item].id ?? 475723497772
        brandProductsViewController.brandProductsViewModel=brandProductsViewModel
        navigationController?.pushViewController(brandProductsViewController, animated: true)
    }
    
    private func configureDiscountCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscountCollectionViewCell.identifier, for: indexPath) as! DiscountCollectionViewCell
        
        cell.configure(image: UIImage(named: discountImages[indexPath.row])!)
        
        return cell
        
    }
    
    private func configureBrandCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as! BrandsCollectionViewCell
        
        cell.brandImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.brandImage.layer.borderWidth=1
        cell.brandImage.layer.cornerRadius=20
        cell.brandName.text=homeViewModel?.getBrands()[indexPath.item].title
        let url=URL(string: homeViewModel?.getBrands()[indexPath.item].image?.src ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg")
        guard let imageUrl=url else{
            print("Error loading image: ",APIError.invalidURL)
            return cell
        }
        cell.brandImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CollectionViewHeaderReusable.identifier,
                for: indexPath) as! CollectionViewHeaderReusable
            header.configure(homeSections[indexPath.section].title)
            return header
            
        case UICollectionView.elementKindSectionFooter:
            
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DiscountPageControlReusableView.identifier,
                for: indexPath) as! DiscountPageControlReusableView
            self.discountPageControlView = footer
            return footer
            
        default:
            return UICollectionReusableView()
            
        }
        
    }
    
}
