//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 12/06/2024.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var moreOrdersBtn: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    var ordersViewModel: OrdersViewModelProtocol?
    let indicator = UIActivityIndicatorView(style: .large)
    let favViewModel = FavouriteViewModel(favSerivce: FavoritesManager.shared)
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib=UINib(nibName: "OrdersTableViewCell", bundle: nil)
        ordersTable.dataSource=self
        ordersTable.delegate=self
        favCollectionView.dataSource = self
        favCollectionView.delegate = self
        favCollectionView.keyboardDismissMode = .onDrag
        favCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let favCellNib=UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        favCollectionView.register(favCellNib, forCellWithReuseIdentifier: "meFavCell")
        ordersTable.register(cellNib, forCellReuseIdentifier: "ordersCell")
        indicator.startAnimating()
        ordersViewModel = OrdersViewModel(service: NetworkService.shared)
        ordersTable.layer.shadowRadius=5
        ordersTable.layer.masksToBounds=false
        ordersTable.layer.shadowColor=UIColor.gray.cgColor
        ordersTable.layer.shadowOffset=CGSize(width: 0, height: 0)
        ordersTable.layer.shadowOpacity = 0.3
        welcomeLabel.text="Welcome, \(CurrentUser.user?.firstName ?? "Customer")"
        favViewModel.bindToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.favCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ordersViewModel?.fetchOrders()
        favViewModel.fetchFavouriteItems()
        indicator.startAnimating()
        moreOrdersBtn.isHidden=true
        ordersViewModel?.bindOrdersToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.ordersTable.reloadData()
                self?.moreOrdersBtn.isHidden = self?.ordersViewModel?.getOrdersCount() ?? 0 > 1 ? false:true
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        
    }
    
    @IBAction func onMoreFav(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
        if let favViewController = storyboard.instantiateViewController(withIdentifier: "FavouriteScreenViewController") as? FavouriteScreenViewController {
            navigationController?.pushViewController(favViewController, animated: true)
        }
    }
    
    @IBAction func settingsBtn(_ sender: UIButton) {
        
        let settingsStoryboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        
        if let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsTableViewController") as? SettingsTableViewController {
            navigationController?.pushViewController(settingsVC, animated: true)
        }
        
    }
}
extension MeViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Israa", bundle: nil)
        guard let orderDetailsViewController = storyboard.instantiateViewController(withIdentifier: "orderDetailsVC") as? OrderDetailsViewController else {
            return
        }
        orderDetailsViewController.orderID = ordersViewModel?.getOrders()[indexPath.row].id
        navigationController?.pushViewController(orderDetailsViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAlert=UIAlertController(title:"Delete order" , message: "Are you sure you want to delete this order?", preferredStyle: .alert)
        let deleteAlertAction=UIAlertAction(title: "Delete", style: .destructive) { [weak self]_ in
            guard let orderId=self?.ordersViewModel?.getOrders()[indexPath.row].id else{
                print("No order if found!")
                return
            }
            self?.ordersViewModel?.deleteOrder(orderId: orderId)      
        }
        let cancelAlertAction=UIAlertAction(title: "Cancel", style: .default)
        deleteAlert.addAction(cancelAlertAction)
        deleteAlert.addAction(deleteAlertAction)
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self](_, _, boolValue) in
            self?.present(deleteAlert, animated: true)
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
    }
}
extension MeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isEmpty = ordersViewModel?.getOrdersCount() == 0
        ordersTable.backgroundView = isEmpty ? getOrdersTableBackgroundView() : nil
        if ordersViewModel?.getOrdersCount() ?? 0 <= 2 {
            return ordersViewModel?.getOrdersCount() ?? 0
        }else{
            return 2
        }
        
    }
    func getOrdersTableBackgroundView() -> UIView {
        let backgroundView = UIView(frame: ordersTable.bounds)
        let imageView = UIImageView(frame: backgroundView.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "noProductsFound")
        backgroundView.addSubview(imageView)
        return backgroundView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        cell.orderPrice.text=(ordersViewModel?.getOrders()[indexPath.row].totalPrice ?? "0.0") + " " + (ordersViewModel?.getOrders()[indexPath.row].currency ?? "USD")
        if let createdAtString = ordersViewModel?.getOrders()[indexPath.row].createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = formatter.date(from: createdAtString) {
                formatter.dateFormat = "yyyy-MM-dd' 'HH:mm"
                let formattedDate = formatter.string(from: date)
                cell.orderDate.text = formattedDate
            } else {
                cell.orderDate.text=ordersViewModel?.getOrders()[indexPath.row].createdAt
                print("Error: Unable to convert date from string")
            }
        } else {
            print("Error: createdAt string is nil")
        }
        return cell
    }
    
    
}


extension MeViewController:UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
        guard let productDetailsViewController = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInfoViewController else {
            return
        }
        productDetailsViewController.productID = favViewModel.favouriteItems[indexPath.item].id
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isEmpty =  favViewModel.favouriteItems.count == 0
        collectionView.backgroundView = isEmpty ? getBackgroundView() : nil
        return min(favViewModel.favouriteItems.count,4)
    }
    func getBackgroundView() -> UIView {
        let backgroundView = UIView(frame: favCollectionView.bounds)
        let imageView = UIImageView(frame: backgroundView.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "noProductsFound")
        backgroundView.addSubview(imageView)
        return backgroundView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "meFavCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.delegate = self
        cell.cellIndex = indexPath.item
        let titleComponents = favViewModel.favouriteItems[indexPath.item].itemName.split(separator: " | ")
        let categoryName = String(titleComponents.last ?? "")
        cell.categoryName.text = categoryName
        cell.updateFavBtnImage(isFav: true)
        cell.categoryPrice.text="      "
        cell.clipsToBounds=true
        cell.layer.cornerRadius=20
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth=0.7
        let url=URL(string: favViewModel.favouriteItems[indexPath.item].imageURL)
        guard let imageUrl=url else{
            print("Error loading image: ",APIError.invalidURL)
            return cell
        }
        cell.categoryImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell
    }
}
extension MeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width=self.view.frame.width*0.44
        let height=width*1.2
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension MeViewController:FavItemDelegate{
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
        print(" deletening Item index = \(itemIndex)")
        showAlert(message: "Are you sure you want to remove this item from your favorites?"){ [weak self] in
            self?.favViewModel.deleteFavouriteItem(itemId:  self?.favViewModel.favouriteItems[itemIndex].id ?? 0)
            self?.favCollectionView.reloadData()
        }
    }
    
    func saveFavItem(itemIndex: Int) {
        print("deletening Item index 2 = \(itemIndex)")
        showAlert(message: "Are you sure you want to remove this item from your favorites?"){ [weak self] in
            self?.favViewModel.deleteFavouriteItem(itemId:  self?.favViewModel.favouriteItems[itemIndex].id ?? 0)
            let indexPath = IndexPath(item: itemIndex, section: 0)
            if let cell = self?.favCollectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
                cell.updateFavBtnImage(isFav: false)
            }
        }
        
    }
    
}
extension MeViewController{
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

