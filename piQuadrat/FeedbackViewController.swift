//
//  FeedbackViewController.swift
//  piQuadrat
//
//  Created by pau on 10/13/17.
//  Copyright © 2017 pau. All rights reserved.
//

import UIKit
import Cosmos

class FeedbackViewController: UIViewController {

    @IBOutlet weak var hilfreich: CosmosView!
    @IBOutlet weak var verstaendlich: CosmosView!
    @IBOutlet weak var interessant: CosmosView!
    @IBOutlet weak var tempo: CosmosView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func writeRatingsInDatabase(_ sender: Any) {
        let ratingArray = [hilfreich.rating,verstaendlich.rating,interessant.rating,tempo.rating]
        var params : [String]
        var request : URLRequest
        for i in 0 ... 3 {
        // func :fuegeBewertungHinzu , param0 --> VideoID, param1 --> SchuelerID, param2 --> BewertungID ,param3 --> Wert
            params  = ["fuegeBewertungHinzu",String(DB.videoID),String(DB.schuelerID),String(i),String(ratingArray[i])];
            request = DB.createRequest(params: params)
            DB.asyncCallforString(request: request, comp: { (reply : (String)) -> () in
            print(reply)
            })
        }
        self.navigationController?.popViewController(animated: true)
        // return String "Eintragen erfolgreich"
    }
    
}
