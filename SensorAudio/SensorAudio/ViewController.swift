//
//  ViewController.swift
//  SensorAudio
//
//  Created by Ben Ha on 1/9/16.
//  Copyright © 2016 Ben Ha. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
      var player: AVAudioPlayer = AVAudioPlayer()
    
    @IBAction func play(sender: AnyObject) {
        
        player.play()
        
        var audioRecorder:AVAudioRecorder!
        
        
     
                     
        }
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioPath = NSBundle.mainBundle().pathForResource("testTone", ofType: "wav")!
        
        do {
            
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            
            
        } catch {
            
            // Process error here
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

