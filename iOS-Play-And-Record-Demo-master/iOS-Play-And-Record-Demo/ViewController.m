

/* Set this to YES to reproduce the playback issue */
#define IMPEDE_PLAYBACK NO

#import "ViewController.h"
#import <AVFoundation/AVAudioSession.h>
@interface ViewController (){
    float decibel;
  //  AVAudioSession *session;
    
    
}

@property (nonatomic)     AVAudioPlayer       *player;
@property (nonatomic)     AVAudioRecorder     *recorder;
@property (nonatomic)     NSString            *recordedAudioFileName;
@property (nonatomic)     NSURL               *recordedAudioURL;
@property(nonatomic, strong) AVAudioPlayer *backgroundMusic;




@end

@implementation ViewController

@synthesize player, recorder, recordedAudioFileName, recordedAudioURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

   
   NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"music"
                                               withExtension:@"mp3"];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError];
    [audioSession setActive:YES error:nil];

    
//   
//    NSError *err = nil;
//    
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//    
//    [session setActive:YES error:&err];
   

//    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile
//                                                            error:nil];
//    self.backgroundMusic.numberOfLoops = -1;
//    [self.backgroundMusic play];
    
 
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(printDecibel)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark Playback


#pragma mark Recording


-(void) printDecibel{
    [recorder updateMeters];
    decibel = [recorder averagePowerForChannel:0];
    _output.text = [NSString stringWithFormat: @"%f", decibel];
    NSLog(@"THE LOG SCORE : %f", decibel);
  
}
- (IBAction)record:(id)sender {
    [self setupAndPrepareToRecord];
    
    [recorder record];
    
    

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
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    // initiate recorder
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:[self recordedAudioURL] settings:recordSetting error:&error];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[self player] stop];
}

@end
