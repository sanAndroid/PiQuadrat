//
//  MyCoursesTableViewController.swift
//  piQuadrat
//
//  Created by pau on 8/7/17.
//  Copyright © 2017 pau. All rights reserved.
//

import UIKit

class MyCoursesTableViewController: UITableViewController {
    
    @IBOutlet var kurseTableView: UITableView!
    //MARK: Properties
    
    var kurse = [String] ()
    var kurseID = [Int] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        let params : [String] = ["gibKursVonSchueler",String(DB.schuelerID)];
        let request = DB.createRequest(params: params)
        DB.asyncCall(requestJSON:  "Kurse", request: request, comp: loadKurse)
    }

    
    public func loadKurse(dataJSON: [[String : Any ]])  {
        print(dataJSON.count)
        if(dataJSON.count==0){
            print("Keine Kurse vorhanden")
            OperationQueue.main.addOperation{
                let alert = UIAlertController(title: "Kein Kurs", message: "Du bist in keinem Kurs eingeschrieben. Du kannst dich einschreiben, indem du auf den + Button klickst und anschließend den Freischaltcode eingibst.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            return
        }else{
            if let kurseJSON = dataJSON as? [[String : String ]]{
                OperationQueue.main.addOperation{

                for (index, kurs) in kurseJSON.enumerated() {
                    //self.kurse.append(kurs["ID"]!)
                    self.kurse.append(kurs["Bezeichnung"]!)
                    self.kurseID.append(Int(kurs["ID"]!)!)

                    print("Kurse:")
                    print(self.kurse)
                    self.kurseTableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func deleteCredentials(_ sender: Any) {
        print("deleteCredentials")
        if DB.accountName != "" {
            do{
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: DB.accountName, accessGroup: KeychainConfiguration.accessGroup)
                try passwordItem.deleteItem()
                DB.accountName = ""
                DB.lehrerID = -1
                DB.schuelerID = -1
                
                UserDefaults.standard.set("", forKey: "AccountType")
                UserDefaults.standard.set("", forKey: "StudentUID")
                UserDefaults.standard.set("", forKey: "TeacherUID")
            } catch{
                fatalError("Could not delete Password - \(error)")
            }
        }
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginScreenVC") as! LoginScreen
        //self.navigationController?.setNavigationBarHidden( true, animated: false)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        //self.navigationController?.pushViewController(loginVC, animated: true)
        //self.navigationController?.popViewController(animated: true)
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kurse.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "einKurs", for: indexPath)

        if let label = cell.textLabel {
            print("indexPath.row")
            print(indexPath.row)
            label.text = String(kurse[indexPath.row])
        }
        return cell
    }
 
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        
        print("indexPath")
        print(indexPath.row)
        DB.kursBezeichnung = self.kurse[indexPath.row]
        DB.kursID = self.kurseID[indexPath.row]
        print("performSegue")
        
        //your code...
        
        
    }
    
    /*
    @IBAction func leaveThisViewController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "vloginScreenVC") as! UIViewController
        self.present(controller, animated: true, completion: { () -> Void in
    })
    }*/
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "goToLogout"{
            DB.lehrerID = -1
            DB.schuelerID = -1
            DB.kursID = -1
            DB.videoURL = "empty"
            print("performSegue")
        }
    }*/
 

}
