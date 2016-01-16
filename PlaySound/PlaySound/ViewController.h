//
//  ViewController.h
//  PlaySound
//
//  Created by Ben Ha on 1/10/16.
//  Copyright © 2016 Ben Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    IBOutlet UIButton *stopButton;
     IBOutlet UIButton *playButton;
     IBOutlet UIButton *recordPauseButton;
    

}
-(IBAction)recordPauseTapped:(id)sender;
-(IBAction)stopTapped:(id)sender;
-(IBAction)playTapped:(id)sender;
@end

