//
//  HelpViewController.m
//  test
//
//  Created by Sakura喵 on 2017/1/1.
//  Copyright © 2017年 CYCU. All rights reserved.
//

#import "HelpViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HelpViewController ()

@end

@implementation HelpViewController{
    AVAudioPlayer * musicPlayer;
}

@synthesize sound;
@synthesize strSound;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /*
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
     */
    
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSString * strMusicFilePath = [[NSBundle mainBundle] pathForResource:@"Spongebob Closing Theme Song" ofType:@"mp3"];
    NSURL * MusicFileURL = [[NSURL alloc] initFileURLWithPath:strMusicFilePath];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:MusicFileURL error:nil];
    [musicPlayer prepareToPlay];
    
    musicPlayer.numberOfLoops = -1;
    
    //pCheckBool.text = strSound;
    
    if ([strSound isEqualToString:@"YES"])
        musicPlayer.volume = 1.0;
    else
        musicPlayer.volume = 0.0;
    
    [musicPlayer play];
    
}

- (IBAction)pStartBack:(id)sender {
    [musicPlayer stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *str ;
    if ([strSound isEqualToString:@"YES"])
        str = @"YES";
    else
        str = @"NO";
    
    id pNextPage = segue.destinationViewController;
    [pNextPage setValue:str forKey:@"strSound"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
