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
        
        if let _ = self.navigationController{
            let logout = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.done, target: self, action: #selector(MegaGridTvc.cancelAction(sender:)))
            self.navigationItem.rightBarButtonItems = [logout]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @objc public func cancelAction(sender: Any) {
        NotificationCenter.default.post(name: NotificationKeys.UserSignOutNotification, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model!.count
    }

    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                                            forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            didEndDisplaying cell: UITableViewCell,
                                                 forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath)
            // Configure the cell...
            return customCell
            //ThirdCell
        }
        else if indexPath.row == 1
        {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "ThirdCell", for: indexPath)
            // Configure the cell...
            return customCell
            //ThirdCell
        }
        else
        {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            // Configure the cell...
            return customCell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row: \(indexPath.row)")
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return model![collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                                             for: indexPath)
            cell.backgroundColor = model![collectionView.tag][indexPath.item]
            return cell
        }
        else if collectionView.tag == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                                             for: indexPath)
            cell.backgroundColor = model![collectionView.tag][indexPath.item]
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                                             for: indexPath) as! PopularCollectionViewCell
            cell.bookTitleLbl.text = "Book No \(indexPath.row)"
            cell.bookSubtitleLbl.text = "Book Description"
            cell.backgroundColor = model![collectionView.tag][indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
