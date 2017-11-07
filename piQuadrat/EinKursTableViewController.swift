//
//  EinKursTableViewController.swift
//  piQuadrat
//
//  Created by pau on 8/8/17.
//  Copyright © 2017 pau. All rights reserved.
//TableViewCell
//
//  Dispays all videos of a course an opens the Avplayer and Feedback Viewcontroller
//
//

import UIKit
import AVKit
import AVFoundation

struct VideoData {
    var beschreibung : String = ""
    var geloescht : Int
    var gewichtung : Int
    var iD : Int
    var pfad : String   = "";
    var schwierigkeit : Int
    var titel : String = "";
    var interaktiverPfad = "";
    var gesehen : Bool;
}
class EinKursTableViewController: UITableViewController {
    //var videos = [String]()
    //var videoURL = [String]()
    var videoDataArray = [VideoData]()
    var currentRow: Int = 0
    var callFeedback : Bool = false
    
    @IBOutlet var filmTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = String(DB.kursBezeichnung)
        currentRow = -1
        callFeedback = false;
        let params : [String] = ["gibVideosVomKurs",String(DB.kursID)];
        let request = DB.createRequest(params: params)
        DB.asyncCall(requestJSON: "Videos", request: request, comp: loadVideos)
        
        print("EinKursTableViewController did Load")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if(callFeedback){
            print("Call Segue to Bewertung")
            // calls: openFeedback
           // performSegue(withIdentifier: "openFeedback", sender: self)
            
           let feedbackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.navigationController?.pushViewController(feedbackVC, animated: false)
            //self.present( feedbackVC, animated: true, completion:nil )
            callFeedback = false
        }
        self.filmTableView.reloadData()
        
    }
    
    public func loadVideos(dataJSON: [[String : Any ]])  {
        print("dataJSON.count")
        print(dataJSON.count)
        if(dataJSON.count==0){
            print("Keine Kurse vorhanden")
            return
        }else{
            print("dataJSON")
             print(dataJSON)

               print("BeforeOperationQue")
                //{
                //Beschreibung = "Einf\U00fchrung in Quadratfunktionen";
                // Geloescht = 0;
                //Gewichtung = 0;
                //ID = 7;
                //Pfad = "videos/W8PFXn2k68MzrcYmSoL.mp4";
                //PfadInteraktiv = "<null>";
                //Schwierigkeit = 0;
                //Titel = "Was ist eine Quadratfunktion";
                OperationQueue.main.addOperation{
                    var hasSeen : Bool = false
                    for (index, video) in dataJSON.enumerated() {
                        let videoId = video["ID"] as! String
                        let params : [String] = ["istVideoFuerKursFreigeschaltet",String(DB.kursID), videoId];
                            let request = DB.createRequest(params: params)

                        
                        DB.asyncCall(requestJSON: "Werte", request: request, comp:  { (permitted : [[String : Any ]] ) -> () in
                            //Checked but not implemented?
                            /*print("params")
                            print(params)
                            print("Freigeschaltet?")
                            print(permitted)
                            */
                            })
                            let paramsSeen : [String] = ["hatSchuelerVideoGesehen",  String(DB.schuelerID), videoId ,String(0)];
                            let requestSeen = DB.createRequest(params: paramsSeen)
                            DB.asyncCallforString(request: requestSeen, comp:  { (seen: String) -> () in
                            //Checked but not implemented?
                                if(seen.range(of: "0") != nil){
                                    print(index)
                                    print("Not Seen")
                                    print(seen)
                                    hasSeen = false
                                }else{
                                    print(index)
                                    print("Seen")
                                    print(seen)
                                    hasSeen = true
                                }
                                print("VideoAppend - Now in Closure")
                                self.videoDataArray.append(VideoData(beschreibung: video["Beschreibung"]! as! String, geloescht: Int(video["Geloescht"]! as! String)!, gewichtung: Int(video["Gewichtung"]! as! String)!, iD: Int(video["ID"]! as! String)!, pfad: String("http://gymbase.net/MatheApp/"+(video["Pfad"]! as! String))!, schwierigkeit: Int(video["Schwierigkeit"]! as! String)!, titel: video["Titel"]! as! String, interaktiverPfad : "nothingAtAll", gesehen : hasSeen))
                            
                                print(index)
                                print(dataJSON.count)
                                if(index==dataJSON.count-1){
                                    self.videoDataArray.sort { (lhs: VideoData, rhs: VideoData) in
                                    return lhs.schwierigkeit < rhs.schwierigkeit
                                    }
                                    print("Here Comes Reload Data")
                                    // Get Info about
                                    self.filmTableView.reloadData()
                                    //Closure Ende
                                    }
                            })
                    }
                }
        }
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
        return videoDataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("CellForRowAt IndexPath:")
        print(indexPath.row)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmTableViewCell", for: indexPath)  as? FilmTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        print("Titel")
        print(videoDataArray[indexPath.row].titel)
        print("Beschreibung")
        print(videoDataArray[indexPath.row].beschreibung)
        cell.caption.text = String(videoDataArray[indexPath.row].titel)
        cell.about.text =   String(videoDataArray[indexPath.row].beschreibung)
        if(videoDataArray[indexPath.row].gesehen){
            cell.hasSeenImageView.image = UIImage(named: "WhiteSpace")
        }else{
            cell.hasSeenImageView.image = UIImage(named: "BlueDot")
        }
        print("TableViewFunction")
        // Return cell.
        return cell
    }

    
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

    
 


    override  func tableView(_ tableView: UITableView, didSelectRowAt
indexPath: IndexPath){
        print("indexPath")
        print(indexPath.row)
        print(videoDataArray[indexPath.row].pfad)
        DB.videoID = videoDataArray[indexPath.row].iD
        currentRow = indexPath.row
        // Set Video gesehen to true in order to remove the blue dot
        videoDataArray[indexPath.row].gesehen = true;
        // TODO: Write has seen to Database
        let paramsGesehen = ["schuelerHatVideoGesehen",String(DB.schuelerID),String(DB.videoID),"stub"];
        let requestGesehen = DB.createRequest(params: paramsGesehen)
        
        DB.asyncCallforString(request: requestGesehen, comp: { (gesehen : (String)) -> () in
                // No Action require here
            print("Gesehen:" + gesehen)
        })
        
        // Check if Video has been rated and set flag if that isn't the case
        let params : [String] = ["existiertBewertung",String(DB.videoID),String(DB.schuelerID)];
        let request = DB.createRequest(params: params)
        DB.asyncCallforString(request: request, comp: { (rating : (String)) -> () in
            print("Rating:")
            print(rating)
            let trimmedRating = rating.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression).trimmingCharacters(in: .whitespaces)
            if trimmedRating == "0" {
                self.callFeedback = true
            }
        })
       
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for movie playback
            try session.setCategory(AVAudioSessionCategoryPlayback,
                                    mode: AVAudioSessionModeMoviePlayback,
                                    options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }

        // Load and Display Video
        DB.videoURL=videoDataArray[indexPath.row].pfad
        let url = URL(string : videoDataArray[indexPath.row].pfad)
        let player = AVPlayer(url: url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        self.present(playerViewController, animated: false) {
           playerViewController.player!.isMuted = false
           playerViewController.player!.play()
        }
        
        // After finishing playing Video (How to check?)
        // Open FeedbackVideoController
        
        
    }
  
    // MARK: - Navigation
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.

    

}
