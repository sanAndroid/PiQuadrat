//
//  ErstelleNeuenSchuelerAccount.swift
//  piQuadrat
//
//  Created by pau on 7/27/17.
//  Copyright © 2017 pau. All rights reserved.
//
//  This VC is called when a new student accound is created

import UIKit

class ErstelleNeuenSchuelerAccount: UIViewController {

    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPasswort1: UITextField!
    @IBOutlet weak var txtPasswort2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: UIButton) {
    //TODO
        
    // Password Length Check
        if !isValidEmail(testStr: txtMail.text!) {
            let alert = UIAlertController(title: "Fehler", message: "Bitte korrekte E-Mail Adresse eingeben!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if txtPasswort1.text != txtPasswort2.text {
            let alert = UIAlertController(title: "Fehler", message: "Die Passwörter stimmen nicht überein!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (txtPasswort1.text?.characters.count)! < 6 {
            let alert = UIAlertController(title: "Fehler", message: "Das Passwort ist zu kurz!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Now do the json stuff
        
        
       
       
        // Already Registered Check Teacher
        let encodedPW = md5(string : ("PspQf" + txtPasswort2.text! + "M77Vs2"))
        let request = DB.createRequest(params: ["existiertSchuelerOderLehrerMitDerMail",txtMail.text!, encodedPW, "HowDoIgetFirebaseID"])
        DB.asyncCallforString(request: request, comp: checkExistAndCreateAccount)

    }
    
    func checkExistAndCreateAccount(serverResponse : String){
        print("checkExistAndCreateAccount")
        print(serverResponse)
        let encodedPW = md5(string : ("PspQf" + txtPasswort2.text! + "M77Vs2"))
        if (serverResponse == "0" || serverResponse == "\r\n0" ) {

        
            let request = DB.createRequest(params: ["schuelerErstellen",txtMail.text!, encodedPW,"HowDoIgetFirebaseID?"])
            DB.asyncCallforString(request: request, comp: accountCreated )
            return
            
        } else {
            OperationQueue.main.addOperation{
                let alert = UIAlertController(title: "Fehler", message: "Ein Account mit dieser E-Mail Adresse ist bereits vorhanden", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
         
 
        
    func accountCreated(serverResponse : String){
        print("accountCreated")
        let encodedPW = md5(string : ("PspQf" + txtPasswort1.text! + "M77Vs2"))
        print(serverResponse)
        if serverResponse == "\r\neingetragen"{
            let params  = ["einloggenSchueler", txtMail.text!,encodedPW];
            let request = DB.createRequest(params: params)
            DB.asyncCall(requestJSON: "Schueler", request: request, comp: schuelerEingeloggt)
        }else{
            OperationQueue.main.addOperation{
                let alert = UIAlertController(title: "Fehler", message: "Der Account konnte nicht erstellt werdens", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
        // Open Next ViewController And Ask for Key
        // Open next Screen to Subscribe to course
        // self.performSegue(withIdentifier: "OpenStudentView", sender:self)
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
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
