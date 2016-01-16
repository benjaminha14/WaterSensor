//
//  ViewController.m
//  PlaySound
//
//  Created by Ben Ha on 1/10/16.
//  Copyright © 2016 Ben Ha. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
@property(nonatomic, strong) AVAudioPlayer *backgroundMusic;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"music"withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile
                                                                  error:nil];
  
  
    
   
    NSArray *pathComponents2 = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"music.mp3",
                               nil];
    // Set path file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                                [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                @"myMusic.m4a",
                                nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSMutableData *recordString = [[NSMutableDictionary alloc]init];
    // Define the recorder setting
    NSDictionary* recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,[NSNumber numberWithInt:44100],AVSampleRateKey,[NSNumber numberWithInt:1],AVNumberOfChannelsKey,[NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,[NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,[NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];
    NSError* error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]]  settings:recordSettings error:&error];
//    
//    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//    [recordSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}
int num = 1;
- (IBAction)playTapped:(id)sender {
//    if(num == 0) num = 1;
//    if (num == 1) num = 0;
    
    while(num ==1) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        self.backgroundMusic.numberOfLoops = -1;
        //[self.backgroundMusic play];
        [recorder updateMeters];
       NSLog(@"%f", [recorder averagePowerForChannel:0]);
    }
//    while (num == 0) {
//        [recorder pause];
//        [self.backgroundMusic pause];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
