//
//  GameViewController.m
//  test
//
//  Created by Sakura喵 on 2016/12/18.
//  Copyright © 2016年 CYCU. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "GameViewController.h"

@implementation GameViewController{
    AVAudioPlayer * musicPlayer;
    AVAudioPlayer * soundPlayer;
    BOOL playSound;
    NSTimer * timer;
}

@synthesize pStageLabel;
@synthesize pStateLabel;
@synthesize soundInGame;
@synthesize strSound;
@synthesize stage;
static NSString *str = @"YES" ;


//-(void)updateTime:(NSTimer *)timer
//{
//    self. accumulatedTime++;
//    NSLog(@"accumulatedTime:%f",self. accumulatedTime);
//}

-(void) update:(NSTimer*) sender {
    if ( stage < 5) // 設定它只有5個stage
      stage++;
    pStageLabel.text = [NSString stringWithFormat:@"%d", stage];
}



- (void)viewDidLoad {

    [super viewDidLoad];
    
    // 設定Timer，每過1秒執行方法
    //    self.accumulatedTime = 0;

    //stage = 1;
    //pStageLabel.text = [NSString stringWithFormat:@"%d", stage];
    //timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    GameScene * game = (GameScene*) scene;
    [game setConnectToSB: pStateLabel];
    [game setConnectToSBstage: pStageLabel];

    // Present the scene.
    [skView presentScene:scene];

    
    /*
     UIImageView * backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
     [self.view addSubview:backgroundView];
     */
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSString * strMusicFilePath = [[NSBundle mainBundle] pathForResource:@"SpongeBob SquarePants theme instrumental" ofType:@"mp3"];
    // NSString * strSoundFilePath = @"";
    
    NSURL * MusicFileURL = [[NSURL alloc] initFileURLWithPath:strMusicFilePath];
    // NSURL * SoundFileURL = [[NSURL alloc] initFileURLWithPath:strSoundFilePath];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:MusicFileURL error:nil];
    // soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:SoundFileURL error:nil];
    
    [musicPlayer prepareToPlay];
    // [soundPlayer prepareToPlay];
    
    musicPlayer.numberOfLoops = -1;
    musicPlayer.volume = 0.7;
    // soundPlayer.volume = 0.7;
    
    //checkBool.text = strSound;
    if ([str isEqual: @"YES"])
        playSound = YES;
    else
        playSound = NO;
    
    
    if (![strSound isEqualToString:@"NO"])
        [musicPlayer play];

    
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)pHelpBtn:(id)sender {
    [musicPlayer stop];
}

- (IBAction)pSoundOn:(id)sender {
    playSound = YES;
    [musicPlayer play];
}

- (IBAction)pSoundOff:(id)sender {
    playSound = NO;
    [musicPlayer stop];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //[musicPlayer dealloc];
    
    if (playSound)
        str = @"YES";
    else
        str = @"NO";
    
    id pNextPage = segue.destinationViewController;
    [pNextPage setValue:str forKey:@"strSound"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([pStageLabel.text  isEqual: @"start"]){ //開始遊戲才開始計時
        stage = 1;//初始化
        [timer invalidate]; //把原本的計時器取消重來 不然週期會變快
        //每隔15秒一個週期
        timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(update:) userInfo:nil repeats:YES];
        pStageLabel.text = [NSString stringWithFormat:@"%d", stage];
    }
}

@end
