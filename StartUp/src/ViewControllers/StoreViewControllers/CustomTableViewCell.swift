//
//  CustomTableViewCell.swift
//  TestTvCv
//
//  Created by Saleh  on 28/1/17.
//  Copyright © 2017 Saleh Masum. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate> (_ dataSourceDelegate: D, forRow row: Int)
    {
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
 ///////////////
    
    @IBAction func authorSeeAllAction(_ sender: UIButton) {
        print("Display all list of authors")
        
    }
    
    @IBAction func popularSeeAllAction(_ sender: UIButton) {
        print("Display all list of popular books")
        
    }

    /////////////
}




