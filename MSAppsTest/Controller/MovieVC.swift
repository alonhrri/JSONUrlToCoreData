//
//  MovieVC.swift
//  MSAppsTest
//
//  Created by Alon Harari on 13/03/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//


import UIKit
import CoreData

class MovieVC: UITableViewController {
    
    

    
    

    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Movie.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "releaseYear", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    private func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    
    
    private let cellID = "cellID"
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    private func createMovieEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context) as? Movie {
            movieEntity.title = dictionary["title"] as? String
            movieEntity.image = dictionary["image"] as? String
            movieEntity.releaseYear = dictionary["releaseYear"] as? Int16 ?? 2019
            movieEntity.rating = dictionary["rating"] as! Double
            movieEntity.genre = dictionary["genre"] as? [String]
            return movieEntity
        }
        return nil
    }
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createMovieEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = nil

        //self.title = "Movie List"
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //tableView.register(MovieCell.self, forCellReuseIdentifier: cellID)
        updateTableContent()
        
    }
    func updateTableContent(){
       
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        
        let service = APIService()
        service.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
            //print(data)
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MovieCell
        if let movie = fetchedhResultController.object(at: indexPath) as? Movie {
            //cell.setMovieCellWith(movie: movie)
            if let title = movie.title {
                cell.titleLabel.text = title
            }
            cell.yearLabel.text = String(movie.releaseYear)
            if let url = movie.image {
                cell.photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
            cell.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width + 30 //60 = sum of labels height
    }
    
}

func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    let headerHeight: CGFloat
    
    switch section {
    case 0:
        // hide the header
        headerHeight = CGFloat.leastNonzeroMagnitude
    default:
        headerHeight = 21
    }
    
    return headerHeight
}
extension MovieVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    //static let mySegueName = "toEdit"
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1) get the movie
        if let movie = fetchedhResultController.object(at: indexPath) as? Movie {
            //2) performSegue*(

            performSegue(withIdentifier: "toDetail", sender: movie)

        }

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let detailVC = segue.destination as? DetailVC {
                let row = tableView.indexPathForSelectedRow!.row
                detailVC.movie = sender as! Movie
            }
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is DetailVC
//        {
//            let vc = segue.destination as? DetailVC
//            //vc?.fuck = "fuck!!!!!!"
//            if let movie = sender as? Movie
//            {
//
//                vc?.title = movie.title
//                vc?._rating = movie.rating
//                vc?._img = movie.image
//                vc?._genre = movie.genre as! [String]
//                vc?._year = movie.releaseYear
//
//
//            }
//        }
//
//
//    }
    
    
    
    
    
}








