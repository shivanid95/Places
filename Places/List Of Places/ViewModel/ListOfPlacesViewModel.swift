//
//  ListOfPlacesViewModel.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import Foundation
import Firebase

protocol ListOfPlacesViewDelegate : Loadable {
    // To refresh views after callback from API Call
    func reloadTableView()
}

protocol ListOfPlacesViewModel {
// variable to delegate all UI activities to view
    
    var viewDelegate  : ListOfPlacesViewDelegate? { get set}
// to fetch the data stream
    var model         : ListOfPlacesModel?        { get set}
    
// to return the data for table view
    func numberOfPlaces() -> Int
    func useItemAt( indexPath : IndexPath) -> PlacesObject?
// to logout users
    func signOutUser(completionHandler : @escaping(Bool , Error?) -> Void)
}

class ListOfPlacesViewModelImplementation :  ListOfPlacesViewModel {
    
    
    var viewDelegate: ListOfPlacesViewDelegate?
    
    private var listOfPlacesArray : [PlacesObject]? {
        didSet {
            viewDelegate?.reloadTableView()
        }
    }
    
    var model: ListOfPlacesModel? {
        didSet {
            
        }
    }
    
    init() {
        self.model = ListOfPlacesModelImplementation()
        viewDelegate?.showLoader()
        model?.fetchPlaces(completionHandler: { [weak self] (places) in
            self?.listOfPlacesArray = places
            self?.viewDelegate?.hideLoader()
        })

    }

    func signOutUser(completionHandler : @escaping(Bool , Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completionHandler(true ,nil )
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completionHandler(false , signOutError)
        }
    }
    
    func numberOfPlaces() -> Int {
        return listOfPlacesArray?.count ?? 0
    }
    
    func useItemAt(indexPath: IndexPath) -> PlacesObject? {
        return listOfPlacesArray?[indexPath.row] 
    }
    
}
