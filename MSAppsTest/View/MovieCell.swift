//
//  MovieCell.swift
//  MSAppsTest
//
//  Created by Alon Harari on 13/03/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//

import Foundation
import UIKit


class MovieCell: UITableViewCell {
    

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    
    @IBOutlet weak var photoImageview: UIImageView!
    
    
    
    
    func setMovieCellWith(movie: Movie) {
        DispatchQueue.main.async {
            self.titleLabel.text = movie.title
            self.yearLabel.text = String(movie.releaseYear)
            if let url = movie.image {
                self.photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
           }
        }
    }
    
    
    
//        let photoImageview: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.backgroundColor = #colorLiteral(red: 0.3371254802, green: 0.3372338414, blue: 0.3455525637, alpha: 1)
//        iv.layer.masksToBounds = true
//        return iv
//    }()
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        label.backgroundColor = #colorLiteral(red: 0.3371254802, green: 0.3372338414, blue: 0.3455525637, alpha: 1)
//        label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        label.textAlignment = .left
//        label.lineBreakMode = .byWordWrapping
//        return label
//    }()
//
//    let yearLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        label.backgroundColor = #colorLiteral(red: 0.3371254802, green: 0.3372338414, blue: 0.3455525637, alpha: 1)
//        label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
//    let dividerLineView: UIView = {
//        let v = UIView()
//        v.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
    
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        isUserInteractionEnabled = false
//
//        addSubview(photoImageview)
//        addSubview(titleLabel)
//        addSubview(yearLabel)
//        //addSubview(dividerLineView)
//
//        photoImageview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
//        photoImageview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        photoImageview.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        photoImageview.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
//
//        titleLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor).isActive = true
//        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
//
////        dividerLineView.topAnchor.constraint(equalTo: photoImageview.bottomAnchor).isActive = true
////        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
////        dividerLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
////        dividerLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
//
//        yearLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        yearLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        yearLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
//        yearLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
//
////        topAnchor
////        photoImageview
////        titleLabel
////        dividerLineView
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}


















