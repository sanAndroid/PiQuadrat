//
//  LoginScreen.swift
//  piQuadrat
//
//  Created by pau on 7/26/17.
//  Copyright © 2017 pau. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var uid: UITextField!
    
    static var correctLogin : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func checkLoginData(_ sender: Any) {
  
        
        // Check Teacher Account
        // Add md5
    
        let pw : String = "PspQf" + pwd.text! + "M77Vs2";
        print("md5")
        print(md5(string : pw))
        let params : [String] = ["einloggenLehrer",uid.text!, md5(string : pw)];
        let request = DB.createRequest(params: params)
        DB.asyncCall(requestJSON: "Lehrer", request: request, comp: lehrerEingeloggt)
        // Check Student Account

    }
    
    public func lehrerEingeloggt(dataJSON: [[String: Any]])  {
        print(dataJSON.count)
        if(dataJSON.count==0){
            print("Lehrer Array ist 0")
            let pw : String = "PspQf" + pwd.text! + "M77Vs2";
            print("md5")
            print(md5(string : pw))
            let params  = ["einloggenSchueler", uid.text!, md5(string : pw)];
            let request = DB.createRequest(params: params)
            DB.asyncCall(requestJSON: "Schueler", request: request, comp: schuelerEingeloggt)
            return
        }else{
            if let lehrerJSON = (dataJSON as! [[String : String ]]).first {
            OperationQueue.main.addOperation{
                DB.lehrerID = Int(lehrerJSON["ID"]!)!
                self.performSegue(withIdentifier: "OpenClassListView", sender:self)}
            }
        }
     
    }
    
        

   
    public func schuelerEingeloggt(dataJSON: [[String: Any]]){
     print("schuelerEinloggen")
     if(dataJSON.count==0){
        OperationQueue.main.addOperation{
            let alert = UIAlertController(title: "Fehler", message: "Es konnte kein Account mit diesen Login Daten gefunden werden", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
    }}else{ 
        
        let schuelerJSON = dataJSON.first  // as! [ String : String ]
            OperationQueue.main.addOperation{
                print("DataJSON")
                print(schuelerJSON)
                if let schuelerID = schuelerJSON?["ID"] as? String {
                    DB.schuelerID = Int(schuelerID)!
                    print(DB.schuelerID)
                    print("Opening Student Sreen")
                    self.performSegue(withIdentifier: "OpenStudentView", sender:self)
                }
                
                
        }
        }
    }
 
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

func md5(string: String) -> String {
    var digestHex : String = ""
    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    if let data = string.data(using: String.Encoding.utf8) {
        data.withUnsafeBytes { dataBytes in
            CC_MD5(dataBytes, CC_LONG(data.count), &digest)
        }
    for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
        digestHex += String(format: "%02x", digest[index])
        }
    }
    return digestHex
}


