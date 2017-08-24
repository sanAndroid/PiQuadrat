//
//  classListViewController.swift
//  piQuadrat
//
//  Created by pau on 8/2/17.
//  Copyright © 2017 pau. All rights reserved.
//

import UIKit

class classListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var meineKlassenTable: UITableView!
   
    var klassen = ["Loading ....","Wait a sec ..."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.meineKlassenTable.dataSource = self;
        self.meineKlassenTable.delegate = self;
        
        let params : [String] = ["kurseVomLehrer","01"];
        let request = DB.createRequest(params : params)
        DB.asyncCall(requestJSON: "Kurse", request: request,comp: populateKList)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func populateKList(kursJSON : [[String : Any ]] ){
        if let kursArray = kursJSON as? [[String : String ]] {
            if kursArray == nil {return}
            klassen.removeAll()
            for kurs in kursArray{
                klassen.append(kurs["Bezeichnung"]!)
            }
            self.meineKlassenTable.dataSource = self;
            print("Populate List")
            self.meineKlassenTable.reloadData()
        }
    }
    
    
    
    
    
    // Needed for TableView delegate
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell.
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eineKlasse") {
            
            // Set text of textLabel.
            // ... Use indexPath.item to get the current row index.
            if let label = cell.textLabel {
                label.text = klassen[indexPath.item]
            }
            // Return cell.
            return cell
        }
        
        // Return empty cell.
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Use length of array a stable row count.
        return klassen.count
    }

}
