//
//  EnterRegistrationKeyViewController.swift
//  piQuadrat
//
//  Created by pau on 8/10/17.
//  Copyright © 2017 pau. All rights reserved.
//

import UIKit

class EnterRegistrationKeyViewController: UIViewController {

    @IBOutlet weak var keyTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        // Check if Key is correct
        let params  = ["schreibeInKursEin", String(DB.schuelerID), keyTextField.text!]
        print(params)
        let request = DB.createRequest(params: params)
        DB.asyncCallforString(request: request, comp: checkForSuccess)
        

        // Register and return
    }
    
    func checkForSuccess( serverResponse : String){
    OperationQueue.main.addOperation{
        print(serverResponse)
        if(serverResponse.contains("eingetragen")){
            
        self.performSegue(withIdentifier: "OpenStudentView", sender:self)
            
            
            
        }else{
                let alert = UIAlertController(title: "Fehler", message: "Es konnte kein Kurs mit diesem Einschreibeschlüssel gefunden werden", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }}
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
