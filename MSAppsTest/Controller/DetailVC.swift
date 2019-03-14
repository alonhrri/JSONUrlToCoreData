//
//  DetailVC.swift
//  MSAppsTest
//
//  Created by Alon Harari on 14/03/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//


import Foundation
import UIKit
import CoreData

class DetailVC: UIViewController {
    
    

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    //stored property (*explicitly unwrapped)
    var movie: Movie!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        self.title = "Movie Details"
        if let title = movie.title {
            self.titleLabel.text = title
        }
        self.ratingLabel.text = "Rating: \(String(movie.rating))"
        self.yearLabel.text = "Release Year: \(String(movie.releaseYear))"
        if let url = movie.image {
            self.photoImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
        }
        
        if movie.genre?.count != 0 {
            var str = "Genre:"
            for item in (movie?.genre)!{
                str += " \(item),"
            }
            self.genreLabel.text = str
        }

        //self.genreLabel.text = movie.genre[0]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
