			//
//  GameViewController.h
//  test
//
//  Created by Sakura喵 on 2016/12/18.
//  Copyright © 2016年 CYCU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "GameScene.h"

//tatic BOOL playClick;

@interface GameViewController : UIViewController

- (IBAction)pHelpBtn:(id)sender;
- (IBAction)pSoundOn:(id)sender;
- (IBAction)pSoundOff:(id)sender;

@property int stage;
@property (strong, nonatomic) IBOutlet UILabel *pStageLabel;
@property (weak, nonatomic) IBOutlet UILabel *pStateLabel;



@property BOOL *soundInGame;
@property NSString *strSound;

@end
