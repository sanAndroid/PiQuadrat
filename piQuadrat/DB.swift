//
//  DB.swift
//  piQuadrat
//
//  Created by pau on 7/27/17.
//  Copyright © 2017 pau. All rights reserved.
//

import Foundation

public class DB{
    
    var wartezeit : Int  = 5;
    public static let AUTHKEY : String = "test321";
    public static let POST_PARAM_KEYVALUE_SEPARATOR : String = "=";
    public static let POST_PARAM_SEPARATOR : String = "&";
    
    private static var aufzurufendeKlasse : String  = "json_get_data.php"; //"Lehrer.php";
    private static var aufzurufendeFunktion : String = "gibAlleLehrer";
    
    public static var lehrerID : Int = -1
    public static var schuelerID : Int = -1
    public static var kursID : Int = -1
    public static var videoID : Int = -1
    public static var kursBezeichnung : String = ""
    public static var videoURL: String = "empty"
    public static var accountName : String = ""
    
    // Call this function with function Name as first parameter and the function's parameter as the subsequent parameters
    // Completion determines what to do with result
    // Use this function for a simple json array of type [String : Any|
    
    static func checkTeacherLogin(params : [String], completion:@escaping (String) -> () ) {
    let request  = DB.createRequest(params : params)
    let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
        if error != nil{
            print("Error Starting URLSession")
            return
        }
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableLeaves)
        if let responseJSON = responseJSON as? [String : Any] {
            print("Cast Worked")
            let teacherJSON = (responseJSON["Lehrer"]!  as? NSArray)?.mutableCopy() as? NSMutableArray
            
            // Bis hierhin
            if(teacherJSON?.count==0){
                print("Empty Array arrived")
                //Try to open as a student
                // Else
                print("I will post an error message")
                completion("This is Bad")
                
            } else {
                print("There's something in the basket")
                completion("Success")
            }
        }
        
    }
    task.resume()
    }

    static func createRequest( params : [String] ) -> URLRequest {
        //Die URL wird zusammengesetzt
        var parameters = params
        parameters.remove(at: 0)
        var dataBuffer :String = ""
        dataBuffer.append("authkey".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
        dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
        dataBuffer.append(AUTHKEY.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
        dataBuffer.append(POST_PARAM_SEPARATOR);
        dataBuffer.append("func".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
        dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
        aufzurufendeFunktion = params[0]
        dataBuffer.append(aufzurufendeFunktion.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
        var i : Int = 0
        for param in parameters {
            dataBuffer.append(POST_PARAM_SEPARATOR);
            dataBuffer.append(("param"+String(i)).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
            dataBuffer.append(param.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
            i+=1
        }
        print(dataBuffer)
        //Adresse der PHP Schnittstelle für die Verbindung zur MySQL Datenbank
        
        //ALT let url = URL(string: "https://gymbase.net/MatheApp/"+aufzurufendeKlasse)!
        let url = URL(string: "https://piquadrat.org/h5p-wp/"+aufzurufendeKlasse)!
        print("URL: ")
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = dataBuffer.data(using: String.Encoding.utf8)
        return request
    }
    
  
    
    // Call this function with function Name as first parameter and the function's parameter as the subsequent parameters
    // Completion determines what to do with result
    // Use this function for a json array of type [[String : Any]]
    static func asyncCall(requestJSON: String, request: URLRequest,comp: @escaping ([[String: Any]]) -> () ){
        
        var re : URLRequest = request
        re.timeoutInterval = 20
        
        let task = URLSession.shared.dataTask(with: re as URLRequest){ data,response,error in
            if error != nil{
                print("Error Starting URLSession")
                return
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
           
            let responseJSON = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableLeaves)
            if let responseJSON = responseJSON as? [String : Any] {
                print("Cast Worked")
                print(responseJSON)
                // Der Suchstring muss mitgeliefert werden möglich "Kurse"/"Lehrer"
             
                guard let arrayJSON = responseJSON[requestJSON]!  as? [[String: Any]] else {
                //guard let arrayJSON = (responseJSON[requestJSON]!  as? NSArray)?.mutableCopy() as? NSMutableArray else {
                    print("Error casting to Array")
                    return
                }
                    if(arrayJSON.count==0){
                        print("Empty Array arrived")
                        comp(arrayJSON)
                        
                    } else {
                        comp(arrayJSON)
                    }
                
            }
        }
        task.resume()
    }
    
    static func insert(parameter : [String]) -> Bool {
        var wert : Bool = false
        wert = true
        
        // Erstelle neues JasonDB Objekt und fange mögliche Fehler ab
        // Checke ob das neue Objekt eingetragen wurde
        return wert
    }
 
    
    static func asyncCallforString(request: URLRequest,comp: @escaping (String) -> () ){
        var re : URLRequest = request
        re.timeoutInterval = 60
        
        let task = URLSession.shared.dataTask(with: re as URLRequest){ data,response,error in
            if error != nil{
                print("Error Starting URLSession")
                return
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            guard let dataAsString = String(data: data, encoding: .utf8) else {
                print("Error casting to String")
                return
            }
            comp(dataAsString)
        }
        task.resume()
    }
    
    

    
/*
    public static func getJSONArray(request: URLRequest, completion: @escaping  ([[String: String]] )-> ()){

        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if error != nil{
                print("Error Starting URLSession")
                return
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableLeaves)
            if let responseJSON = responseJSON as? [String: Any] {
                if let retValue = responseJSON["server_response"] as? [[String: String]] {
                    // Hier ist the json Array -> Completion shoud be implemented here
                    completion(retValue)
                }
            }
        }
        task.resume()
    }

        
    */
  /*
    
public static func openConnection( params : [String] ) -> [String: Any]  {
    //Die URL wird zusammengesetzt
    var retValue : [String: Any] = ["empty" : "empty"]
 
    
    var dataBuffer :String = ""
    dataBuffer.append("authkey".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
    dataBuffer.append(DB.POST_PARAM_KEYVALUE_SEPARATOR);
    dataBuffer.append(AUTHKEY.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
    dataBuffer.append(POST_PARAM_SEPARATOR);
    dataBuffer.append("func".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
    dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
    dataBuffer.append(aufzurufendeFunktion.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
    var i : Int = 0
    for param in params {
        dataBuffer.append(POST_PARAM_SEPARATOR);
        dataBuffer.append(("param"+String(i)).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
        dataBuffer.append(param.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!);
        i+=1
    }
    
    //Adresse der PHP Schnittstelle für die Verbindung zur MySQL Datenbank
    
    let url = URL(string: "http://gymbase.net/MatheApp/"+aufzurufendeKlasse)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = dataBuffer.data(using: String.Encoding.utf8)
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
        if error != nil{
            print("Error Starting URLSession")
            return
        }
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableLeaves)
        if let responseJSON = responseJSON as? [String: Any] {
            retValue = responseJSON
            print(responseJSON)
        }
    }
    task.resume()
    }
    
    */
    
    // public static String selectString(String [] parameter){
    //static func selectString(parameter: [String]) -> String {
    //var jsonStr: String = "null"
    //JsonDB db = new JsonDB();
    //db.execute(parameter);
    /*try {
     jsonStr = db.get(wartezeit, TimeUnit.SECONDS);
     System.out.println("jsonString = " + jsonStr);
     } catch (InterruptedException e) {
     e.printStackTrace();
     } catch (ExecutionException e) {
     e.printStackTrace();
     } catch (TimeoutException e) {
     e.printStackTrace();
     }*/
    // return jsonStr;
    //}
    
    //public static JSONObject select(String [] parameter){
    //static func select(parameter: [String]) -> JSONOBject {
    /*
     }
     JSONObject jsonObj = null;
     JsonDB db = new JsonDB();
     db.execute(parameter);
     try {
     String jsonStr = db.get(wartezeit, TimeUnit.SECONDS);
     System.out.println("jsonString = " + jsonStr);
     jsonObj = new JSONObject(jsonStr);
     } catch (InterruptedException e) {
     e.printStackTrace();
     } catch (ExecutionException e) {
     e.printStackTrace();
     } catch (JSONException e) {
     e.printStackTrace();
     } catch (TimeoutException e) {
     e.printStackTrace();
     }
     return jsonObj; */
    // }
    
    //public static JSONArray select(String [] parameter, String jsonName){
    //static func select(parameter: [String]) -> JSONArray {
    /* JSONArray jsonArray = null;
     JsonDB db = new JsonDB();
     db.execute(parameter);
     try {
     String jsonStr = db.get(wartezeit, TimeUnit.SECONDS);
     System.out.println("jsonString = " + jsonStr);
     JSONObject jsonObj = new JSONObject(jsonStr);
     jsonArray = jsonObj.getJSONArray(jsonName);
     } catch (InterruptedException e) {
     e.printStackTrace();
     } catch (ExecutionException e) {
     e.printStackTrace();
     } catch (JSONException e) {
     e.printStackTrace();
     } catch (TimeoutException e) {
     e.printStackTrace();
     }
     return jsonArray; */
    //}
    

}
