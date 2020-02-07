//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Maxim Alekseev on 03.02.2020.
//  Copyright © 2020 Maxim Alekseev. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    private let searchController = UISearchController (searchResultsController: nil)
    private var places: Results<Place>!
    private var filteredPlaces: Results <Place>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        //Setup search controller
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
   
   
    //  MARK: - Navigation
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place: Place
            if isFiltering {
                place = filteredPlaces [indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
            
        }
     }
     
    // MARK: - @IBActions
    
    @IBAction func unwindSegue ( _ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        newPlaceVC.savePlace()
        
        tableView.reloadData()
    }
    
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
       sorting()
    }
    
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
            
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    
    //MARK: - Sorting
    
    private func sorting() {
        
         if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
         } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

// MARK: - Table

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  
    // MARK: Table view data source
       
       
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if isFiltering {
               return filteredPlaces.count
           }
           return places.isEmpty ? 0 : places.count
           
       }
       
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
           
           var place = Place()
           
           if isFiltering {
               place = filteredPlaces[indexPath.row]
           } else {
               place = places[indexPath.row]
           }
           
                  
           cell.nameLabel.text = place.name
           cell.locationLabel.text = place.location
           cell.typeLabel.text = place.type
           cell.imageOfPlace.image = UIImage(data: place.imageData!)
           
           
           cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
           cell.imageOfPlace.clipsToBounds = true
           
           
           return cell
       }
       
       // MARK: Table View Delegate
       
       func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let place  = places[indexPath.row]
           let deleteAction = UIContextualAction (style: .destructive, title: "Delete") { (action, view, handler) in
               StorageManager.deleteObject(place)
               tableView.deleteRows(at: [indexPath], with: .automatic)
           }
           deleteAction.backgroundColor = .red
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
           
       }
       
       /*
        
        //In earlier iOS:
        
        override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place  = places[indexPath.row]
        let deleteAction = UITableViewRowAction (style: .default, title: "Delete") { (_, _) in
        StorageManager.deleteObject(place)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        }
        
        return [deleteAction]
        }
        */
       
}


//MARK: - Searching
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
    private func filterContentForSearchText (_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
}
