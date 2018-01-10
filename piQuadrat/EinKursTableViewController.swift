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
    var verstanden : Int
}


class EinKursTableViewController: UITableViewController{
    //var videos = [String]()
    //var videoURL = [String]()
    var videoDataArray = [VideoData]()
    var currentRow: Int = 0
    var callFeedback : Bool = false
    var callUnderstanding : Bool = false
    var understandingUp2Date : Bool = false
    var hasSeenUp2Date = false
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
        if(callUnderstanding){
            print("Call Segue to Understandin")
            let feedbackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UnterstoodViewController") as! UnterstoodViewController
            self.navigationController?.pushViewController(feedbackVC, animated: false)
            //self.present( feedbackVC, animated: true, completion:nil )
            callUnderstanding = false
        }
        
        if(callFeedback){
            print("Call Segue to Bewertung")
           let feedbackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.navigationController?.pushViewController(feedbackVC, animated: false)
            //self.present( feedbackVC, animated: true, completion:nil )
            callFeedback = false
        }
        self.filmTableView.reloadData()
        self.adjustBewertung()
        //self.hasStudentSeen()
    }
    
    public func loadVideos(dataJSON: [[String : Any ]])  {
        print("dataJSON.count")
        print(dataJSON.count)
        understandingUp2Date = false
        hasSeenUp2Date = false
        if(dataJSON.count==0){
            print("Keine Kurse vorhanden")
            return
        }else{
            print("dataJSON")
            print(dataJSON)
            print("BeforeOperationQue")
            OperationQueue.main.addOperation{
                for (index, video) in dataJSON.enumerated() {
                    let videoId = video["ID"] as! String
                    // Hier war ein Check ob das Video freigeschaltet wurde
                    let paramsSeen : [String] = ["hatSchuelerVideoGesehen",  String(DB.schuelerID), videoId ,String(0)];
                    let requestSeen = DB.createRequest(params: paramsSeen)
                    DB.asyncCallforString(request: requestSeen, comp:  { (seen: String) -> () in
                        print("VideoAppend - Now in Closure")
                        print(video)
                        var interPfad = "empty"
                        if video["PfadInteraktiv"] is String {
                            print("Belege den Interaktiven Pfad")
                            interPfad  = video["PfadInteraktiv"] as! String
                        }
                        self.videoDataArray.append(VideoData(beschreibung: video["Beschreibung"]! as! String, geloescht: Int(video["Geloescht"]! as! String)!, gewichtung: Int(video["Gewichtung"]! as! String)!, iD: Int(video["ID"]! as! String)!, pfad: String("http://gymbase.net/MatheApp/"+(video["Pfad"]! as! String))!, schwierigkeit: Int(video["Schwierigkeit"]! as! String)!, titel: video["Titel"]! as! String, interaktiverPfad : interPfad , gesehen : true, verstanden : 0))
                        print(index)
                        print(dataJSON.count)
                        if(index==dataJSON.count-1){
                            self.videoDataArray.sort { (lhs: VideoData, rhs: VideoData) in
                                return lhs.schwierigkeit < rhs.schwierigkeit
                            }
                            //print("Here Comes Reload Data")
                            DispatchQueue.main.async{
                                print("Here Comes Reload Data")
                                // Refresh the TableView and load extra Data
                                self.adjustBewertung()
                                self.hasStudentSeen()
                                self.filmTableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
   
        
    //func adjustBewertung(videoIndex : IndexPath){
    func adjustBewertung(){
        // get param0 --> VideoID
        // get param1 --> SchuelerID
        // get param2 --> Kategorie
        
        for index in 0...(videoDataArray.count - 1) {
            var video = videoDataArray[index]
            let params = ["gibBewertung",String(video.iD),String(DB.schuelerID),String(5)];
            let request = DB.createRequest(params: params)
            DB.asyncCallforString(request: request, comp: { (bewertung :  (String)) -> () in
                let trimmedBewertung = bewertung.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression).trimmingCharacters(in: .whitespaces)
                print("Bewertung:")
                print(trimmedBewertung)
                if Int(trimmedBewertung) != nil{
                    print("Eingetragen!")
                    self.videoDataArray[index].verstanden = Int(trimmedBewertung)!
                }else{
                     self.videoDataArray[index].verstanden = 0
                }
                print(index)
                
                print(self.videoDataArray.count)
                if(index == self.videoDataArray.count - 1 ){
                        print("ReloadData")
                        DispatchQueue.main.async{
                            self.filmTableView.reloadData();
                    }
                }
        })
        }
    }
    
        func hasStudentSeen(){
            // get param0 --> SchuelerID
            // get param1 --> VideoID
            // get param2 --> Gesehen/True/False
            for index in 0...(videoDataArray.count - 1) {
                let paramsSeen : [String] = ["hatSchuelerVideoGesehen",  String(DB.schuelerID), String(videoDataArray[index].iD) ,String(0)];
                let requestSeen = DB.createRequest(params: paramsSeen)
                DB.asyncCallforString(request: requestSeen, comp:  { (seen: String) -> () in
                    //Checked but not implemented?
                    if(seen.range(of: "0") != nil){
                        //print(self.index)
                        print("Not Seen")
                        print(seen)
                        self.videoDataArray[index].gesehen = false
                    }else{
                        //print(self.index)
                        print("Seen")
                        print(seen)
                        self.videoDataArray[index].gesehen = true
                    }
                    DispatchQueue.main.async{
                        if(index == self.videoDataArray.count - 1){
                            print("UpdatedHasSeen")
                            self.filmTableView.reloadData();
                            self.hasSeenUp2Date = true
                        }
                    }
                })
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
    
    // Configure the the TableViewCells and set the data accordingly
    // Ideally should be called always, when the videoDataArray has been updated
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("CellForRowAt IndexPath:")
        print(indexPath.row)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmTableViewCell", for: indexPath)  as? FilmTableViewCell else {
            fatalError("The dequeued cell is not an instance of FilmTableViewCell.")
        }
        
        print("Titel")
        if( indexPath.row < videoDataArray.count ){
            print(videoDataArray[indexPath.row].beschreibung)
            cell.caption.text = String(videoDataArray[indexPath.row].titel)
            cell.about.text =   String(videoDataArray[indexPath.row].beschreibung)
            if(videoDataArray[indexPath.row].gesehen){
                cell.hasSeenImageView.image = UIImage(named: "WhiteSpace")
            }else{
                cell.hasSeenImageView.image = UIImage(named: "GreenMainDot")
            }
            print("Verstanden: ")
            print(videoDataArray[indexPath.row].verstanden)
            switch videoDataArray[indexPath.row].verstanden {
            case 0 :
                cell.levelOfUnderstanding.image = UIImage(named: "WhiteSpace")
            case 1 :
                cell.levelOfUnderstanding.image = UIImage(named: "No_Hand")
            case 2 :
                cell.levelOfUnderstanding.image = UIImage(named: "Ok_Hand")
            case 3 :
                cell.levelOfUnderstanding.image = UIImage(named: "Y_Hand")
            default :
                cell.levelOfUnderstanding.image = UIImage(named: "WhiteSpace")
            }
        }
        print("TableViewFunction")
        /*
        if(!understandingUp2Date){
            adjustBewertung(videoIndex: indexPath)
        } if(!hasSeenUp2Date){
            hasStudentSeen(videoIndex :  indexPath)
        }
         */
        // Return cell.
        return cell
    }

    

    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Adapt User level of Understanding and Change thumb direction
    // Called when the user slides the cell to the left
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       DB.videoID = videoDataArray[indexPath.row].iD
        
        
        //Easy Action -> Light green thumb showing up
        let easyAction = UITableViewRowAction(style: .default, title: "Easy!", handler: { (action, indexPath) in
            let params  = ["fuegeBewertungHinzu",String(DB.videoID),String(DB.schuelerID),String(5),String(3)];
            let request = DB.createRequest(params: params)
            if let cell = self.filmTableView.cellForRow(at: indexPath) as? FilmTableViewCell {
                cell.levelOfUnderstanding.image = UIImage(named: "Y_Hand")
            }
            
            DB.asyncCallforString(request: request, comp: {(reply : (String )) -> () in
                print("Reply:")
                print(reply)
                DispatchQueue.main.async{
                   // self.filmTableView.reloadData();
                }
            })
        })
        
         //Ok Action -> Middle green thumb going sideways
        let okAction = UITableViewRowAction(style: .default, title: "Ok", handler: { (action, indexPath) in
            let params  = ["fuegeBewertungHinzu",String(DB.videoID),String(DB.schuelerID),String(5),String(2)];
            let request = DB.createRequest(params: params)
            if let cell = self.filmTableView.cellForRow(at: indexPath) as? FilmTableViewCell {
                cell.levelOfUnderstanding.image = UIImage(named: "Ok_Hand")
            }
            DB.asyncCallforString(request: request, comp: {(reply : (String )) -> () in
                print("Reply:")
                print(reply)
                DispatchQueue.main.async{
                     //self.filmTableView.reloadData();
                }
            })
        })
        
        //No Action (Like oh,no!!!) -> Dark green thumb going down
        let noAction = UITableViewRowAction(style: .default, title: "No!", handler: { (action, indexPath) in
            if let cell = self.filmTableView.cellForRow(at: indexPath) as? FilmTableViewCell {
                cell.levelOfUnderstanding.image = UIImage(named: "No_Hand")
            }
            let params  = ["fuegeBewertungHinzu",String(DB.videoID),String(DB.schuelerID),String(5),String(1)];
            let request = DB.createRequest(params: params)
            DB.asyncCallforString(request: request, comp: {(reply : (String )) -> () in
                print("Reply:")
                print(reply)
             
            })
        })
        easyAction.backgroundColor = UIColor(red: 0.75,green: 0.882,blue: 0.878,alpha: 1)
        okAction.backgroundColor = UIColor( red: 0.0470, green: 0.638, blue: 0.68, alpha: 1)
        noAction.backgroundColor = UIColor(red: 0.145, green: 0.41176, blue: 0.517, alpha: 1)
        return [easyAction,okAction,noAction]
    }
    


    // Start Video and update Database
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(videoDataArray[indexPath.row].interaktiverPfad)
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
                self.callUnderstanding = true
            }
        })
        if ( !videoDataArray[indexPath.row].gesehen) {
            self.callFeedback = true
            self.callUnderstanding = true
        }
        let interaktiveVideoURL =  "https://piquadrat.org/h5p-wp/showVideo.php?uname=" + DB.accountName + "&videoURL=" + 
            videoDataArray[indexPath.row].interaktiverPfad
        //let interaktiveVideoURL =  "https://piquadrat.org/" + videoDataArray[indexPath.row].interaktiverPfad
        print("interaktiveVideoURL:" + interaktiveVideoURL)
        if let videoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "interaktivesVideo") as? InteraktivesVideoViewController{
            videoViewController.url = interaktiveVideoURL
            
            if let navigator = navigationController {
                navigator.pushViewController(videoViewController, animated: true)
            }
        }
        

        // Here the AVPart is starting - Replace with Webview
        
        /*let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for movie playback
            try session.setCategory(AVAudioSessionCategoryPlayback,
                                    mode: AVAudioSessionModeMoviePlayback,
                                    options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
         */
        // Load and Display Video
        DB.videoURL=videoDataArray[indexPath.row].pfad
        
        /*let url = URL(string : videoDataArray[indexPath.row].pfad)
        let player = AVPlayer(url: url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        self.present(playerViewController, animated: false) {
           playerViewController.player!.isMuted = false
           playerViewController.player!.play()
        }
     */
    }
    
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
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.

    

}
