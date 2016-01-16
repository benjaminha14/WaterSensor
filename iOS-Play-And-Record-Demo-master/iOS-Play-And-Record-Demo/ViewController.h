//
//  ViewController.h
//  iOS-Play-And-Record-Demo
//
//  Created by Matthew Loseke on 2/24/14.
//  Copyright (c) 2014 Matthew Loseke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioSessionManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *output;

@end
