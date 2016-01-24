//
//  ViewController.swift
//  ToneGenerator
//
//  Created by Ben Ha on 1/16/16.
//  Copyright © 2016 Ben Ha. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    var playSound : AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            //catching the error.
        }
        playSound = setupAudioPlayerWithFile("music", type: "mp3");
        playSound?.volume = 0.5;
        playSound?.numberOfLoops = -1;
        playSound?.play();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }


}

