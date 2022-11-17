//
//  LoginScreen.swift
//  piQuadrat
//
//  Created by pau on 7/26/17.
//  Copyright © 2017 pau. All rights reserved.
//
//  LoginScreen, manages login and credentials etc.
import UIKit
    import CryptoKit

class LoginScreen: UIViewController {
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var uid: UITextField!

    static var correctLogin : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Do any additional setup after loading the view.
        // Check if credentials exist and jump directly to MyCourses if
        // Teacher credentials
        // Student credentials
        do{
        if let accountType = UserDefaults.standard.string(forKey: "AccountType"){
            switch accountType {
            case "StudentAccount":
                let studentUID = UserDefaults.standard.string(forKey: "StudentUID")!
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: studentUID, accessGroup: KeychainConfiguration.accessGroup)
                let pw = try passwordItem.readPassword()
                let params  = ["einloggenSchueler", studentUID, pw];
                let request = DB.createRequest(params: params)
                DB.asyncCall(requestJSON: "Schueler", request: request, comp: schuelerEingeloggt)
            case "TeacherAccount":
                let teacherUID = UserDefaults.standard.string(forKey: "TeacherUID")!
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: teacherUID, accessGroup: KeychainConfiguration.accessGroup)
                let pw = try passwordItem.readPassword()
                let params  = ["einloggenLehrer", teacherUID , pw];
                let request = DB.createRequest(params: params)
                DB.asyncCall(requestJSON: "Lehrer", request: request, comp: teacherLoggedIn)
            default:
                print("No credentials found")
            }
    }
        } catch {
            fatalError("Inconsistent Data in Keychain - \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Clear password und uid when view is reloaded
            pwd.text = ""
            uid.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func checkLoginData(_ sender: Any) {
        // Check Teacher Account
        let pw : String = "PspQf" + pwd.text! + "M77Vs2";
        let params : [String] = ["einloggenLehrer",uid.text!, md5(string : pw)];
        DB.accountName = uid.text!
        let request = DB.createRequest(params: params)
        // Checks if it is a valid teacher Account, if not call schuelerEingeloggt
        DB.asyncCall(requestJSON: "Lehrer", request: request, comp: teacherLoggedIn)

    }
    
    public func teacherLoggedIn(dataJSON: [[String: Any]])  {
        print(dataJSON.count)
        if(dataJSON.count==0){
            print("Lehrer Array ist 0")
            let pw : String = "PspQf" + pwd.text! + "M77Vs2";
            let params  = ["einloggenSchueler", uid.text!, md5(string : pw)];
            let request = DB.createRequest(params: params)
            DB.asyncCall(requestJSON: "Schueler", request: request, comp: schuelerEingeloggt)
            return
        }else{
            if let lehrerJSON = (dataJSON as! [[String : String ]]).first {
            OperationQueue.main.addOperation{
                // Save credentials for Teacher
                UserDefaults.standard.set(DB.accountName, forKey: "TeacherUID")
                UserDefaults.standard.set("TeacherAccount", forKey: "AccountType")
                let pw : String = md5(string: "PspQf" + self.pwd.text! + "M77Vs2")
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: DB.accountName, accessGroup: KeychainConfiguration.accessGroup)
                do {
                    try passwordItem.savePassword(pw)
                    print("Password in Keychain")
                    let pawd : String  = try passwordItem.readPassword()
                    print(pawd)
                } catch {
                    fatalError("Error updating keychain - \(error)")
                }
                //Open next Scene
                DB.lehrerID = Int(lehrerJSON["ID"]!)!
                self.performSegue(withIdentifier: "OpenClassListView", sender:self)}
            }
        }
     
    }
    
        

   // Check if it is a valid Student Account
    public func schuelerEingeloggt(dataJSON: [[String: Any]]){
     print("schuelerEinloggen")
     if(dataJSON.count==0){
        OperationQueue.main.addOperation{
            let alert = UIAlertController(title: "Fehler", message: "Es konnte kein Account mit diesen Login Daten gefunden werden", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
    }
     }else{
        
        let schuelerJSON = dataJSON.first  // as! [ String : String ]
            OperationQueue.main.addOperation{
                print("DataJSON")
                print(schuelerJSON)
                if let schuelerID = schuelerJSON?["ID"] as? String {
                    DB.schuelerID = Int(schuelerID)!
                    print(DB.schuelerID)
                    
                    // Safe Credentials
                    UserDefaults.standard.set(DB.accountName, forKey: "StudentUID")
                    UserDefaults.standard.set("StudentAccount", forKey: "AccountType")
                    print("Safe Credentials:" + DB.accountName )
                    let pw : String = md5(string: "PspQf" + self.pwd.text! + "M77Vs2")
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: DB.accountName, accessGroup: KeychainConfiguration.accessGroup)
                    do {
                        try passwordItem.savePassword(pw)
                        print("Password in Keychain")
                        let pawd : String  = try passwordItem.readPassword()
                        print(pawd)
                    } catch {
                         fatalError("Error updating keychain - \(error)")
                    }
                    
                    
                    print("Opening Student Sreen")
                    self.performSegue(withIdentifier: "OpenStudentView", sender:self)
                    
                }
                
                
        }
        }
    }
 
    
    

    // MARK: - Navigation

    
    
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
    let computed = Insecure.MD5.hash(data: string.data(using: .utf8)!)
    return computed.map { String(format: "%02hhx", $0) }.joined()
}


