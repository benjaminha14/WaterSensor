

/* Set this to YES to reproduce the playback issue */
#define IMPEDE_PLAYBACK NO

#import "ViewController.h"
#import <AVFoundation/AVAudioSession.h>
#include <sys/types.h>
#include <sys/sysctl.h>
@interface ViewController ()<CLLocationManagerDelegate>{
    int avg;
    int highDeci;
    float decibel;
    int count;
    double average;
    double actualDecibel;
    int smallestDecibel;
    //  AVAudioSession *session;
    NSTimer *averageTimer;
    NSTimer *lowTimer;
    NSTimer *highTimer;
    NSTimer *labelTimer;
    NSTimer *uploadTimer;
     CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    NSString *response;
    
    
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
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback
    //                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
    //                        error:&setCategoryError];
    //    [audioSession setActive:YES error:nil];
    
    
    //
    //    NSError *err = nil;
    //
    //    [session setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    //
    //    [session setActive:YES error:&err];
    
    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile
                                                                  error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    
    smallestDecibel = 100;
    //

    

    
    
   
}


#pragma mark Playback


#pragma mark Recording

-(int)averageDecibel{
    [recorder updateMeters];
   return[recorder averagePowerForChannel:0];
    
}

- (IBAction)record:(id)sender {
    
    [self setupAndPrepareToRecord];
    [recorder record];
    [self.backgroundMusic play];
    
    averageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(runningAverage)
                                           userInfo:nil
                                            repeats:YES];
    highTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(highestDecible)
                                   userInfo:nil
                                    repeats:YES];
    lowTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(lowestDecible)
                                   userInfo:nil
                                    repeats:YES];
    labelTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(labelText)
                                   userInfo:nil
                                    repeats:YES];
    uploadTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                   target:self
                                                 selector:@selector(uploadData)
                                                 userInfo:nil
                                                  repeats:YES];
    
    
    
    
    
    
    
}

-(void)uploadData{
    PFObject *waterData = [PFObject objectWithClassName:@"WaterData"];
    waterData[@"average"] = @(avg);
    if(smallestDecibel != 0){
        waterData[@"lowest"] = @(smallestDecibel);
    }
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
            // do something with the new geoPoint
            waterData[@"location"] = geoPoint;
        
    }];

    
    waterData[@"highest"] = @((abs)(highDeci));
    [waterData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
    
    

}

//Dont touch
- (IBAction)stop:(id)sender {
    [self resetRunningAverage];
    [averageTimer invalidate];
    [highTimer invalidate];
    [lowTimer invalidate];
    [labelTimer invalidate];
    [self.backgroundMusic pause];
}
-(void)resetRunningAverage{
    average = 0;
    count = 0;
    avg = 0;
    
    
}
-(void) runningAverage{
    average += (abs)([self averageDecibel]);
    count++;
    avg = (int)( average/count);
     _average.title = [NSString stringWithFormat: @"Average: %d", avg];
    
}
-(void) highestDecible{
    int normalDeci = [self averageDecibel];
    highDeci = (int)[recorder peakPowerForChannel:0];
    if((abs)(highDeci) < (abs)(normalDeci)){
        highDeci = normalDeci;
    }
    _high.title = [NSString stringWithFormat: @"Highest: %d", (abs)(highDeci)];
    
}
-(void)lowestDecible{
    if([recorder peakPowerForChannel:0] < smallestDecibel){
        smallestDecibel = decibel;
    }
    _low.title = [NSString stringWithFormat: @"Lowest: %d", (abs)(smallestDecibel)];
}
/*
-(int) convertPercentage{
 
}*/
-(void)labelText{
    int *localDecibal = 0;
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    if ([sDeviceModel isEqual:@"iPhone8,1"]){
        localDecibal = 30;
    }
    
    if((abs)([self averageDecibel]) > 60){
        response = @"Dry";
    }else if ((abs)([self averageDecibel]) <= 60 && (abs)([self averageDecibel])>=43)
    {
        response = @"Moist";
    }else{
        response = @"Wet";
    }
    _output.text = [NSString stringWithFormat: @"%@", response];
    
}

- (void)setupAndPrepareToRecord
{
    if (!IMPEDE_PLAYBACK) {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayAndRecord];
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
