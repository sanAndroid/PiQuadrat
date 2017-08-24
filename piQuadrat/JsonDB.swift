//
//  JsonDB.swift
//  piQuadrat
//
//  Created by pau on 7/27/17.
//  Copyright © 2017 pau. All rights reserved.
//
 /*
 * Wichtig: als Parameter muss übergeben werden im Array
 * [0] = aufzurufende PHP Datei
 * [1] = aufzurufende Funktion in PHP Datei
 * [...] = Parameter
 */
/*
import Foundation

public class JsonDB{
    public let AUTHKEY : String = "test321";
    public let POST_PARAM_KEYVALUE_SEPARATOR : String = "=";
    public let POST_PARAM_SEPARATOR : String = "&";
    
    // diese Werte werden durch die Parameterübergabe überschrieben;
    private var aufzurufendeKlasse : String  = "json_get_data.php"; //"Lehrer.php";
    private var aufzurufendeFunktion : String = ""; //"gibAlleLehrer";

    
    private func openConnection( params : [String] ){
    //StringBuffer für das zusammensetzen der URL
    
    var dataBuffer :String = ""
        dataBuffer.append("authkey");
        dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
        dataBuffer.append(AUTHKEY);
        dataBuffer.append(POST_PARAM_SEPARATOR);
        dataBuffer.append("func");
        dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
        dataBuffer.append(aufzurufendeFunktion);
  
        var i : Int = 0
        for param in params {
            dataBuffer.append(POST_PARAM_SEPARATOR);
            dataBuffer.append("param")
            dataBuffer.append(String(i));
            dataBuffer.append(POST_PARAM_KEYVALUE_SEPARATOR);
            dataBuffer.append(param);
            i+=1
        }
        // Convert String to UTF8 URL Format
        dataBuffer = dataBuffer.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
    
    //Adresse der PHP Schnittstelle für die Verbindung zur MySQL Datenbank
    
    let url = URL(string: "http://gymbase.net/MatheApp/"+aufzurufendeKlasse)!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let error = error {
        // If there is an error in the web request, print it to the console
        print(error)
        return
    }
        // Because we'll be calling a function that can throw an error
        // we need to wrap the attempt inside of a do { } block
        // and catch any error that comes back inside the catch block
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            self.didReceive(searchResult: jsonResult)
        }
        catch let err {
            print(err.localizedDescription)
        }
        // Close the dataTask block, and call resume() in order to make it run immediately
        }.resume()
    }
    
    
    func didReceive(searchResult: [String: Any]) {
        // Make sure the results are in the expected format of [String: Any]
        guard let results = searchResult["results"] as? [[String: Any]] else {
            print("Could not process search results...")
            return
        }
        
        // Create a temporary place to add the new list of app details to
        var apps = [[String: String]]()
        
        // Loop through all the results...
        for result in results {
            // Check that we have String values for each key we care about
            if let thumbnailURLString = result["artworkUrl100"] as? String,
                let appName = result["trackName"] as? String,
                let price = result["formattedPrice"] as? String {
                // All three data points are valid, add the record to the list
                apps.append(
                    [
                        "thumbnailURLString": thumbnailURLString,
                        "appName": appName,
                        "price": price
                    ]
                )
            }
        }
        // Update our tableData variable as a way to store
        // the list of app's data we pulled out of the JSON
        tableData = apps
        // Refresh the table with the new data
        DispatchQueue.main.async {
            self.appsTableView.reloadData()
        }
    }

    }


}
 */
