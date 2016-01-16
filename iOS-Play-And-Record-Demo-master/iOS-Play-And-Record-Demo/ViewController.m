//
//  ViewController.m
//  iOS-Play-And-Record-Demo
//
//  Created by Matthew Loseke on 2/24/14.
//  Copyright (c) 2014 Matthew Loseke. All rights reserved.
//

/* Set this to YES to reproduce the playback issue */
#define IMPEDE_PLAYBACK NO

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic)     AVAudioPlayer       *player;
@property (nonatomic)     AVAudioRecorder     *recorder;
@property (nonatomic)     NSString            *recordedAudioFileName;
@property (nonatomic)     NSURL               *recordedAudioURL;

- (IBAction)play:(id)sender;
- (IBAction)recordingForTouchDown:(id)sender;
- (IBAction)endRecording:(id)sender;

@end

@implementation ViewController

@synthesize player, recorder, recordedAudioFileName, recordedAudioURL;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (IMPEDE_PLAYBACK) {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayAndRecord];
    }
}

#pragma mark Playback

- (IBAction)play:(id)sender
{
    if (!IMPEDE_PLAYBACK) {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
    }
    
    NSError *audioError;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self recordedAudioURL] error:&audioError];
    player.delegate = self;
    [player play];
}

#pragma mark Recording

- (IBAction)recordingForTouchDown:(id)sender
{
    [self setupAndPrepareToRecord];
    [recorder recordForDuration:30];
}

- (IBAction)endRecording:(id)sender
{
    [recorder stop];
}

- (void)setupAndPrepareToRecord
{
    if (!IMPEDE_PLAYBACK) {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
    }

    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:1];
    recordedAudioFileName = [NSString stringWithFormat:@"%@", date];
    
    // sets the path for audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               [NSString stringWithFormat:@"%@.m4a", [self recordedAudioFileName]],
                               nil];
    recordedAudioURL = [NSURL fileURLWithPathComponents:pathComponents];

    // settings for the recorder
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // initiate recorder
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:[self recordedAudioURL] settings:recordSetting error:&error];
    [recorder prepareToRecord];
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[self player] stop];
}

@end
