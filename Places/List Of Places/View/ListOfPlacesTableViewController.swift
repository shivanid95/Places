//
//  TableViewController.swift
//  Places
//
//  Created by Shivani Dosajh on 24/02/18.
//

import UIKit

class ListOfPlacesTableViewController: UITableViewController {
    
    var viewModel : ListOfPlacesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
         }
    }
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName =  UINib(nibName: Constants.listOfPlacesNibName, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: Constants.listOfPlacesCellID)
        navigationItem.hidesBackButton = true
        
        viewModel = ListOfPlacesViewModelImplementation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel?.numberOfPlaces() ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.listOfPlacesCellID, for: indexPath) as? PlacesTableViewCell
        cell?.loadCell(withName: viewModel?.useItemAt(indexPath: indexPath)?.name)
        
        return cell ?? UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let descriptionVC =   UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.locationDescriptionViewNibName) as! LocationDescriptionViewController
        
        descriptionVC.viewModel = LocationDescriptionViewModelImplemenatation(placeObject: (viewModel?.useItemAt(indexPath: indexPath))!)
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
    //MARK: Actions
    
    @IBAction func didTapLogoutButton(_ sender: UIBarButtonItem) {
       let alert = UIAlertController(title: "Places App", message: "Want to logout?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self](alert) in
            self?.viewModel?.signOutUser{ (isSuccess , error) in
                if (isSuccess) {
                    self?.navigationController?.popViewController(animated: true)
                    
                } else  {
                    let errorAlert = UIAlertController(title: "Logout Failiure", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    self?.present(errorAlert, animated: true, completion: nil)
                }
            }
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)

    }
    
}
extension ListOfPlacesTableViewController : ListOfPlacesViewDelegate , Loadable {
    
    func showLoader() {
        showLoadingView()
    }
    
    func hideLoader() {
        hideLoadingView()
    }
    
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
}

