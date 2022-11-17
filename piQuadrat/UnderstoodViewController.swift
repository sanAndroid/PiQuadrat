//
//  UnterstoodViewController.swift
//  piQuadrat
//
//  Created by pau on 11/12/17.
//  Copyright © 2017 pau. All rights reserved.
//  This ViewController appears directly after the FeedbackViewController
//  The User can set his level of understanding which will be shown in EinKursTableView

import UIKit

@objcMembers class UnderstoodViewController: UIViewController {
    var currentImage = 0
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeLeft)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.thumbImageTapped(_:)))
        thumb.addGestureRecognizer(tapGesture)
}


func thumbImageTapped(_ sender: UITapGestureRecognizer ){
    print("TapGestureRegcognizedf")
    let alert = UIAlertController(title: "Bedienung", message: "Ziehe deinen Daumen nach oben, links oder rechts, um deinen Verständnisgrad für das Video anzupassen", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
}
    
func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            print("Right Recognized")
            thumb.image = UIImage(named: "MiddleThumb")
            currentImage = 2;
        case UISwipeGestureRecognizer.Direction.down:
            print("Down Recognized")
            thumb.image = UIImage(named: "DarkThumb")
            currentImage = 3;
        case UISwipeGestureRecognizer.Direction.left:
            print("Left Recognized")
            thumb.image = UIImage(named: "MiddleThumb");
            currentImage = 2;
        case UISwipeGestureRecognizer.Direction.up:
            print("Up Recognized")
            thumb.image = UIImage(named: "LightThumb")
            currentImage = 1
        default:
            break
        }
        print("VideoID:")
        print(DB.videoID)
        let params  = ["fuegeBewertungHinzu",String(DB.videoID),String(DB.schuelerID),String(5),String(currentImage)];
        let request = DB.createRequest(params: params)
        DB.asyncCallforString(request: request, comp: {(reply : (String )) -> () in
            print("Reply:")
            print(reply)
            DispatchQueue.main.async{
                 self.navigationController?.popViewController(animated: true)
            }
           
        })
       
    }
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

  
    @IBAction func updateBewertung(_ sender: Any) {
    print("updateBewertung")
            // func :fuegeBewertungHinzu , param0 --> VideoID, param1 --> SchuelerID, param2 --> BewertungID ,param3 --> Wert
            let params  = ["fuegeBewertungHinzu",String(DB.videoID),String(DB.schuelerID),String(5),String(currentImage)];
            let request = DB.createRequest(params: params)
            DB.asyncCallforString(request: request, comp: { (reply : (String)) -> () in
                print(reply)
                OperationQueue.main.addOperation{
                    self.navigationController?.popViewController(animated: true)
                }
            })
        //self.navigationController?.popViewController(animated: true)
        // return String "Eintragen erfolgreich"
    }
}
