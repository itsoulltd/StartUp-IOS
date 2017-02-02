//
//  MegaGridTvc.swift
//  TestTvCv
//
//  Created by Saleh  on 28/1/17.
//  Copyright © 2017 Saleh Masum. All rights reserved.
//

import UIKit


class MegaGridTvc: UITableViewController {
    
    var model: [[UIColor]]?
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = generateRandomData()
        
        self.title = "My Grid"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model!.count
    }

    
    override func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? CustomTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(tableView: UITableView,
                            didEndDisplayingCell cell: UITableViewCell,
                                                 forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? CustomTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let customCell = tableView.dequeueReusableCellWithIdentifier("SecondCell", forIndexPath: indexPath)
            // Configure the cell...
            return customCell
            //ThirdCell
        }
        else if indexPath.row == 1
        {
            let customCell = tableView.dequeueReusableCellWithIdentifier("ThirdCell", forIndexPath: indexPath)
            // Configure the cell...
            return customCell
            //ThirdCell
        }
        else
        {
            let customCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            // Configure the cell...
            return customCell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected row: \(indexPath.row)")
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 140
        }
        else if indexPath.row == 1
        {
            return 209
        }
        else
        {
            return 250
        }
    }
    
    func generateRandomData() -> [[UIColor]] {
        let numberOfRows = 20
        let numberOfItemsPerRow = 15
        
        return (0..<numberOfRows).map { _ in
            return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
        }
    }
    //////

}

extension MegaGridTvc: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return model![collectionView.tag].count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                                                                             forIndexPath: indexPath)
            cell.backgroundColor = model![collectionView.tag][indexPath.item]
            return cell
        }
        else if collectionView.tag == 1
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                                                                             forIndexPath: indexPath)
            cell.backgroundColor = model![collectionView.tag][indexPath.item]
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                                                                             forIndexPath: indexPath) as! PopularCollectionViewCell
            cell.bookTitleLbl.text = "Book No \(indexPath.row)"
            cell.bookSubtitleLbl.text = "Book Description"
            cell.backgroundColor = model![collectionView.tag][indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("row no: \(collectionView.tag) and item no: \(indexPath.item)")
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
