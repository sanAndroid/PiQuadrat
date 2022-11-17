//
//  InteraktivesVideoViewController.swift
//  
//
//  Created by pau on 11/7/17.
//  Thiv VC displays h5p videos in WebViews

import UIKit
import WebKit
import AVKit
import AVFoundation

class InteraktivesVideoViewController: UIViewController,  WKUIDelegate, WKNavigationDelegate {

    var videoWebView: WKWebView!
    var url : String = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true;
        webConfiguration.preferences.javaScriptEnabled = true;
        webConfiguration.allowsPictureInPictureMediaPlayback = true;
        videoWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        videoWebView.uiDelegate = self
        view = videoWebView
    }
    
    override func viewDidLoad() {
        videoWebView.navigationDelegate = self
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for movie playback
            try session.setCategory(AVAudioSession.Category.playback,
                                        mode: AVAudioSession.Mode.moviePlayback,
                                        options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
        print("InteraktivesVideoControllerURL: " + url)
        super.viewDidLoad()
        if let videoURL = URL(string: url){
            videoWebView.load(URLRequest(url: videoURL))
        }
    }
    
    func webView(_ videoWebView: WKWebView, didFinish navigation: WKNavigation!) {
        print("loaded")
      
        // Simulate UI Touch or similar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When phone is turned
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         //videoWebView.reloadFromOrigin()
        videoWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if UIDevice.current.orientation.isLandscape {
           
            print("Landscape")
        } else {
            
            print("Portrait")
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

}
