//
//  GameScene.m
//  test
//
//  Created by Sakura喵 on 2016/12/18.
//  Copyright © 2016年 CYCU. All rights reserved.
//

#import "GameScene.h"


#define NUM_BUBBLE 4
#define NUM_jellyfish 8
#define NUM_BOSS 3

@interface GameScene()<SKPhysicsContactDelegate>{
    SKSpriteNode* _bob;
    SKSpriteNode* _bubble[NUM_BUBBLE];
    SKSpriteNode* _jellyfish[NUM_jellyfish];
    SKSpriteNode* _boss[NUM_BOSS];
    SKSpriteNode* _dead;
}
@end

@implementation GameScene {
    UILabel * pConnectToSB;
    UILabel * pConnectToSBstage;
    //NSTimer * timer;
}

static SKTexture* bobTexture ;
static SKTexture* bubbleTexture;
static SKTexture* jellyfishTexture;
static SKTexture* bossTexture;
static SKTexture* deadTexture;
	
static int pos  ; // 0 for left, 1 for right
static const uint32_t worldCategory = 1 << 1;
static BOOL up;
static BOOL down;
static int life;
static int count;
static int touch_count;
static NSString *lastStage;

static int now_bubble;
static int now_jellyfish;
static int now_boss;



-(CGRect) getRect: (SKSpriteNode*) pNode{
    CGRect rect ;
    rect.origin = pNode.position;
    rect.size = pNode.size ;
    return rect ;
    
}



- (void) setConnectToSBstage: (UILabel*) label {
    pConnectToSBstage = label;
}



- (void) setConnectToSB: (UILabel*) label {
    pConnectToSB = label;
}



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // initial
        life = 3;
        up = NO;
        down = NO;
        pos = 1;
        count = 0;
        touch_count = 0;
        lastStage = pConnectToSBstage.text;
        
        self.physicsWorld.contactDelegate = self;
        
        // Create background
        SKTexture* backgroundTexture = [SKTexture textureWithImageNamed:@"2"];
        backgroundTexture.filteringMode = SKTextureFilteringNearest;
        
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [bg setScale:2.2]; // 設定背景圖片大小
        bg.position = CGPointMake( self.size.width/2, self.size.height/2);
        
        [self addChild:bg];
        
        
        // create character
        bobTexture = [SKTexture textureWithImageNamed:@"bob-esponja"];
        bobTexture.filteringMode = SKTextureFilteringNearest;
        
        bubbleTexture = [SKTexture textureWithImageNamed:@"bubble"];
        bubbleTexture.filteringMode = SKTextureFilteringNearest;
        
        jellyfishTexture = [SKTexture textureWithImageNamed:@"joyfish"];
        jellyfishTexture.filteringMode = SKTextureFilteringNearest;
        
        bossTexture = [SKTexture textureWithImageNamed:@"boss"];
        bossTexture.filteringMode = SKTextureFilteringNearest;
        
        deadTexture = [SKTexture textureWithImageNamed:@"dead"];
        deadTexture.filteringMode = SKTextureFilteringNearest;
        
        
         // creat up&down physics container
         // 讓海綿寶寶不會超出畫面上下左右邊界
         SKNode* up = [SKNode node];
         up.position = CGPointMake(0, self.size.height-50);
         up.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width*2, 5)];
         up.physicsBody.dynamic = NO;
         up.physicsBody.categoryBitMask = worldCategory;
         [self addChild:up];
        
         SKNode* down = [SKNode node];
         down.position = CGPointMake(0, 0);
         down.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width*2, 5)];
         down.physicsBody.dynamic = NO;
         down.physicsBody.categoryBitMask = worldCategory;
         [self addChild:down];
        
         SKNode* left = [SKNode node];
         left.position = CGPointMake(0, 0);
         left.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(5, self.size.height*2)];
         left.physicsBody.dynamic = NO;
         left.physicsBody.categoryBitMask = worldCategory;
         [self addChild:left];
        
         SKNode* right = [SKNode node];
         right.position = CGPointMake(self.size.width, 0);
         right.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(5, self.size.height*2)];
         right.physicsBody.dynamic = NO;
         right.physicsBody.categoryBitMask = worldCategory;
         [self addChild:right];
        
        
        NSLog(@"Init Pos: %f",_bob.position.y - _bob.size.height/2);
        /*
        NSLog(@"Init Life: %d",life);
        NSLog(@"Init Count: %d",count);
         */
        
    }
    return self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    touch_count++;
    
    if (touch_count == 1){
        /*
        [_dead removeFromParent];
        _dead = NULL;
         */
        
        pConnectToSBstage.text = @"start";
        
        // present bob
        _bob = [SKSpriteNode spriteNodeWithTexture:bobTexture];
        [_bob setScale:0.08]; //設定海綿寶寶大小
        _bob.position = CGPointMake(self.frame.size.width / 4, self.frame.size.height / 2);
        
        // creat circle physics body
        
        //_bob.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_bob]];

        _bob.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_bob.size.width, _bob.size.height)];
        _bob.physicsBody.dynamic = YES;
        _bob.physicsBody.allowsRotation = NO;
        [self addChild:_bob];

    }

    
    self.physicsWorld.gravity = CGVectorMake( 0, -2.0);
    if ( down == YES || up == NO){
        down = NO;
        if ( pos == 0){ // to left
            _bob.physicsBody.velocity = CGVectorMake(-100, 60);
            [_bob.physicsBody applyImpulse:CGVectorMake(0,35)];
            //NSLog(@"To left");
        }
        
        else if ( pos == 1){ // to right
            _bob.physicsBody.velocity = CGVectorMake(100, 60);
            [_bob.physicsBody applyImpulse:CGVectorMake(0,35)];
            //NSLog(@"To right");
        }
    }
    

    if ( touch_count != 1){
        _bob.position = CGPointMake(_bob.position.x, _bob.position.y+3);
        count = 0;
    }

    
    //[self checkHit] ;
    
    /*
    NSLog(@"Touch Pos: %f",_bob.position.y - _bob.size.height/2);
    NSLog(@"Touch Life: %d",life);
    NSLog(@"Touch Count: %d",count);
     */
    //NSLog(@"Touch_count: %d",touch_count);

}

- (void) checkPosition {
    if( _bob.position.y + _bob.size.height >= self.size.height-50){ // up side
        _bob.physicsBody.velocity = CGVectorMake(0, 0);
        [_bob.physicsBody applyImpulse:CGVectorMake(0,-100)];
        up = YES;
        //NSLog(@"up");
    }
    else if ( _bob.position.x + _bob.size.width >= self.frame.size.width ){ // right side
        pos = 0;
        _bob.physicsBody.velocity = CGVectorMake(-100, 60);
        [_bob.physicsBody applyImpulse:CGVectorMake(0,35)];
        bobTexture = [SKTexture textureWithImageNamed:@"bob-esponja_reverse"];
        _bob.texture = bobTexture;
        //NSLog(@"right");
    }
    
    else if ( _bob.position.x - _bob.size.width <= 0 ){ // left side
        pos = 1;
        _bob.physicsBody.velocity = CGVectorMake(100, 60);
        [_bob.physicsBody applyImpulse:CGVectorMake(0, 35)];
        bobTexture = [SKTexture textureWithImageNamed:@"bob-esponja"];
        _bob.texture = bobTexture;
        //NSLog(@"left");
    }
    else if ( _bob.position.y - _bob.size.height/2 <= 5 ){
        if ( up == YES) down = YES;
        up = NO;
        life = life - 1;
        count = 1;
        //NSLog(@"down");
    }
}


- (void) checkLife {
    
    if (life == 3 && touch_count >0){
        /*
        [_dead removeFromParent];
        _dead = NULL;
         */
        pConnectToSB.text = @"❤❤❤";
        lastStage = pConnectToSBstage.text;
    }
    else if (life == 2)
        pConnectToSB.text = @"❤❤💔";
    else if (life == 1)
        pConnectToSB.text = @"❤💔💔";
    else if (life == 0) {
        
        pConnectToSB.text = @"Game Over";
        _bob.physicsBody.dynamic = NO;
        touch_count = 0;
        life = 3;
        [_bob removeFromParent];
        _bob = NULL;
        
        /*
        _dead = [SKSpriteNode spriteNodeWithTexture:deadTexture];
        [_dead setScale:0.9]; //設定大小
        _dead.position = CGPointMake(self.size.width/2,self.size.height/2);
        
        // creat circle physics body
        _dead.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_dead]];
        _dead.physicsBody.dynamic = NO;
        _dead.physicsBody.allowsRotation = NO;
        [self addChild:_dead];
         */
        
        if ([lastStage isEqualToString:@"1"]){
            [_bubble[0] removeFromParent]; //移除上一階的物件
            _bubble[0] = NULL;

        }
        else if ([lastStage isEqualToString:@"2"]){
            for (int i = 0 ; i < 2 ; i++) {
                [_bubble[i] removeFromParent];
                _bubble[i]= NULL;
                [_jellyfish[i] removeFromParent];
                _jellyfish[i] = NULL;

            }

        }
        else if ([lastStage isEqualToString:@"3"]){
            // 3: 3,4,1
            
            for (int i = 0 ; i < 3 ; i++) {
                [_bubble[i] removeFromParent];
                _bubble[i]= NULL;
                [_jellyfish[i] removeFromParent];
                _jellyfish[i] = NULL;

            }
            
            [_jellyfish[3] removeFromParent];
            _jellyfish[3] = NULL;
            [_boss[0] removeFromParent];
            _boss[0] = NULL;


        }
        else if ([lastStage isEqualToString:@"4"]){
            // 4: 4,6,2
            
            for (int i = 0 ; i < NUM_BUBBLE ; i++) {
                [_bubble[i] removeFromParent];
                _bubble[i]= NULL;
                [_jellyfish[i] removeFromParent];
                _jellyfish[i] = NULL;

            }
            
            [_jellyfish[4] removeFromParent];
            _jellyfish[4] = NULL;
            [_jellyfish[5] removeFromParent];
            _jellyfish[5] = NULL;
            [_boss[0] removeFromParent];
            _boss[0] = NULL;
            [_boss[1] removeFromParent];
            _boss[1] = NULL;
        }
        else if ([lastStage isEqualToString:@"5"]){
            // 5: 0,8,3
            
            for (int i = 0 ; i < NUM_jellyfish ; i++) {
                [_jellyfish[i] removeFromParent];
                _jellyfish[i] = NULL;
            }

            for (int i = 0 ; i < NUM_BOSS ; i++){
                [_boss[i] removeFromParent];
                _boss[i] = NULL;

            }
        }

    }
}

-(void)nextstage{
    
    // bubble 0.25, jellyfish 1.3, boss 0.17
    
    // 1: 1,0,0
    // 2: 2,2,0
    // 3: 3,4,1
    // 4: 4,6,2
    // 5: 0,8,3
    
    // Width:1024, Height:768
    
    if([pConnectToSBstage.text isEqualToString:@"1"] && lastStage != pConnectToSBstage.text ){
        
        // present
        _bubble[0] = [SKSpriteNode spriteNodeWithTexture:bubbleTexture];
        
        [_bubble[0] setScale:0.25]; //設定大小
        _bubble[0].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
        
        // creat circle physics body
        _bubble[0].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_bubble[0]]];
        
        //_bubble[0].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_bubble[0].size.width, _bubble[0].size.height)];
        
        
        _bubble[0].physicsBody.dynamic = NO;
        _bubble[0].physicsBody.allowsRotation = NO;
        [self addChild:_bubble[0]];
        
        // bubble
       
        lastStage = pConnectToSBstage.text ;

        
    }
    
    
    else if([pConnectToSBstage.text isEqualToString:@"2"]  && lastStage != pConnectToSBstage.text){
        [_bubble[0] removeFromParent]; //移除上一階的物件
        _bubble[0] = NULL;

        

        for (int i = 0 ; i < 2 ; i++) {     // 2: 2,2,0
            
            // present
            _bubble[i] = [SKSpriteNode spriteNodeWithTexture:bubbleTexture];
            [_bubble[i] setScale:0.25]; //設定大小
            _bubble[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _bubble[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_bubble[i]]];
            //_bubble[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_bubble[i].size.width,_bubble[i].size.height)];
            _bubble[i].physicsBody.dynamic = NO;
            _bubble[i].physicsBody.allowsRotation = NO;
            [self addChild:_bubble[i]];
            
            // bubble
            
            
            _jellyfish[i] = [SKSpriteNode spriteNodeWithTexture:jellyfishTexture];
            [_jellyfish[i] setScale:1.3]; //設定大小
            _jellyfish[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
        
            // creat circle physics body
            _jellyfish[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_jellyfish[i]]];
            //_jellyfish[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_jellyfish[i].size.width, _jellyfish[i].size.height) ];
            _jellyfish[i].physicsBody.dynamic = NO;
            _jellyfish[i].physicsBody.allowsRotation = NO;
            [self addChild:_jellyfish[i]];
        
            // jellyfish

        
            lastStage = pConnectToSBstage.text ;
        }
        
    }
    else if([pConnectToSBstage.text isEqualToString:@"3"]  && lastStage != pConnectToSBstage.text){
        
        for (int i = 0 ; i < 2 ; i++) { //移除上一階的物件
            [_bubble[i] removeFromParent];
            _bubble[i] = NULL;
            [_jellyfish[i] removeFromParent];
            _jellyfish[i] = NULL;

        }
        
        for (int i = 0 ; i < 3 ; i++) {    // 3: 3,4,1
            // present
            _bubble[i] = [SKSpriteNode spriteNodeWithTexture:bubbleTexture];
            [_bubble[i] setScale:0.25]; //設定大小
            _bubble[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _bubble[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_bubble[i]]];
            //_bubble[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_bubble[i].size.width, _bubble[i].size.height) ];
            _bubble[i].physicsBody.dynamic = NO;
            _bubble[i].physicsBody.allowsRotation = NO;
            [self addChild:_bubble[i]];
            
            // bubble
            
            _jellyfish[i] = [SKSpriteNode spriteNodeWithTexture:jellyfishTexture];
            [_jellyfish[i] setScale:1.3]; //設定大小
            _jellyfish[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _jellyfish[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_jellyfish[i]]];
            //_jellyfish[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_jellyfish[i].size.width, _jellyfish[i].size.height)];
            _jellyfish[i].physicsBody.dynamic = NO;
            _jellyfish[i].physicsBody.allowsRotation = NO;
            [self addChild:_jellyfish[i]];
            
            // jellyfish
        }
        
        
        // present
        _jellyfish[3] = [SKSpriteNode spriteNodeWithTexture:jellyfishTexture];
        [_jellyfish[3] setScale:1.3]; //設定大小
        _jellyfish[3].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
        
        // creat circle physics body
        _jellyfish[3].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_jellyfish[3]]];
        _jellyfish[3].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_jellyfish[3].size.width, _jellyfish[3].size.height)];
        _jellyfish[3].physicsBody.dynamic = NO;
        _jellyfish[3].physicsBody.allowsRotation = NO;
        [self addChild:_jellyfish[3]];
        
        // jellyfish
        
        // present
        _boss[0] = [SKSpriteNode spriteNodeWithTexture:bossTexture];
        [_boss[0] setScale:0.17]; //設定大小
        _boss[0].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
        
        // creat circle physics body
        _boss[0].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_boss[0]]];
        //_boss[0].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_boss[0].size.width, _boss[0].size.height)];
        _boss[0].physicsBody.dynamic = NO;
        _boss[0].physicsBody.allowsRotation = NO;
        [self addChild:_boss[0]];
        
        // boss
        
        lastStage = pConnectToSBstage.text ;
        
    }
    else if([pConnectToSBstage.text isEqualToString:@"4"]  && lastStage != pConnectToSBstage.text){
        
        for (int i = 0 ; i < 3 ; i++) {//移除上一階的物件
            [_bubble[i] removeFromParent];
            _bubble[i] = NULL;
            [_jellyfish[i] removeFromParent];
            _jellyfish[i] = NULL;

        }
        
        [_jellyfish[3] removeFromParent];
        _jellyfish[3] = NULL;
        [_boss[0] removeFromParent];
        _boss[0] = NULL;

        
        
        for (int i = 0 ; i < NUM_BUBBLE ; i++) {
            // present
            _bubble[i] = [SKSpriteNode spriteNodeWithTexture:bubbleTexture];
            [_bubble[i] setScale:0.25]; //設定大小
            _bubble[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _bubble[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_bubble[i]]];
            //_bubble[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_bubble[i].size.width, _bubble[i].size.height) ];
            _bubble[i].physicsBody.dynamic = NO;
            _bubble[i].physicsBody.allowsRotation = NO;
            [self addChild:_bubble[i]];
            
            // bubble
            
            _jellyfish[i] = [SKSpriteNode spriteNodeWithTexture:jellyfishTexture];
            [_jellyfish[i] setScale:1.3]; //設定大小
            _jellyfish[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _jellyfish[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_jellyfish[i]]];
            //_jellyfish[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_jellyfish[i].size.width, _jellyfish[i].size.height)];
            _jellyfish[i].physicsBody.dynamic = NO;
            _jellyfish[i].physicsBody.allowsRotation = NO;
            [self addChild:_jellyfish[i]];
            
            // jellyfish
        }

        for (int i = 0 ; i < 2 ; i++) {
            int j = i + 4 ;
            _jellyfish[j] = [SKSpriteNode spriteNodeWithTexture:jellyfishTexture];
            [_jellyfish[j] setScale:1.3]; //設定大小
            _jellyfish[j].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _jellyfish[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_jellyfish[i]]];
            //_jellyfish[j].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_jellyfish[i].size.width, _jellyfish[j].size.height) ];
            _jellyfish[j].physicsBody.dynamic = NO;
            _jellyfish[j].physicsBody.allowsRotation = NO;
            [self addChild:_jellyfish[j]];
            
            // jellyfish
            
            
            // present
            _boss[i] = [SKSpriteNode spriteNodeWithTexture:bossTexture];
            [_boss[i] setScale:0.17]; //設定大小
            _boss[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _boss[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_boss[i]]];
            //_boss[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_boss[i].size.width, _boss[i].size.height)];
            _boss[i].physicsBody.dynamic = NO;
            _boss[i].physicsBody.allowsRotation = NO;
            [self addChild:_boss[i]];
            
            // boss
            
        }
        
        lastStage = pConnectToSBstage.text ;
        
    }
    else if([pConnectToSBstage.text isEqualToString:@"5"]  && lastStage != pConnectToSBstage.text){
        
        for (int i = 0 ; i < NUM_BUBBLE ; i++) {
            [_bubble[i] removeFromParent];
            _bubble[i] = NULL;
            _jellyfish[i] = NULL;
            [_jellyfish[i] removeFromParent];
        }
        
        [_jellyfish[4] removeFromParent];
        _jellyfish[4] = NULL;
        [_jellyfish[5] removeFromParent];
        _jellyfish[5] = NULL;
        [_boss[0] removeFromParent];
        _boss[0] = NULL;
        [_boss[1] removeFromParent];
        _boss[1] = NULL;

        


        for (int i = 0 ; i < NUM_jellyfish ; i++){
            _jellyfish[i] = [SKSpriteNode spriteNodeWithTexture:jellyfishTexture];
            [_jellyfish[i] setScale:1.3]; //設定大小
            _jellyfish[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _jellyfish[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_jellyfish[i]]];
            //_jellyfish[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_jellyfish[i].size.width, _jellyfish[i].size.height) ];
            _jellyfish[i].physicsBody.dynamic = NO;
            _jellyfish[i].physicsBody.allowsRotation = NO;
            [self addChild:_jellyfish[i]];
            
            // jellyfish
        }
        
        for (int i = 0 ; i < NUM_BOSS ; i++){
            // present
            _boss[i] = [SKSpriteNode spriteNodeWithTexture:bossTexture];
            [_boss[i] setScale:0.17]; //設定大小
            _boss[i].position = CGPointMake(arc4random()%900+50,arc4random()%600+50);
            
            // creat circle physics body
            _boss[i].physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: [self getRect:_boss[i]]];
            //_boss[i].physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_boss[i].size.width, _boss[i].size.height) ];
            _boss[i].physicsBody.dynamic = NO;
            _boss[i].physicsBody.allowsRotation = NO;
            [self addChild:_boss[i]];
            
            // boss
        }

        lastStage = pConnectToSBstage.text ;
    }
    
}



-(void) checkHit {
    
    for( int i = 0 ; i < now_bubble  ; i++ ) {
        if ( CGRectIntersectsRect( [self getRect:(_bob)] , [self getRect:(_bubble[i])] )) {
            if ( life < 3 )
              life++ ;
            // 讓泡泡不見
            [_bubble[i] removeFromParent];
            _bubble[i] = NULL;
            //NSLog( @">>>Bubble Bob_x:%f Bob_y:%f Bubble_x:%f Bubble_y:%f I:%d",_bob.position.x,_bob.position.y,_bubble[i].position.x,_bubble[i].position.y,i);
        }
    } // for life +#
    
    for ( int i = 0 ; i < now_jellyfish ; i++ ) {
        if ( CGRectIntersectsRect( [self getRect:(_bob)] , [self getRect:(_jellyfish[i])] )) {
            if ( life > 0 )
              life-- ;
            // 讓水母不見
            [_jellyfish[i] removeFromParent];
            _jellyfish[i] = NULL;
            //NSLog( @">>>jellyfish Bob_x:%f Bob_y:%f jellyfish_x:%f jellyfish_y:%f I:%d",_bob.position.x,_bob.position.y,_jellyfish[i].position.x,_jellyfish[i].position.y,i);
        }
    } // for life -

    for ( int i = 0 ; i < now_boss ; i++ ) {
        if ( CGRectIntersectsRect( [self getRect:(_bob)] , [self getRect:(_boss[i])] )) {
            life = 0 ;
            // 讓boss不見
            [_boss[i] removeFromParent];
            _boss[i] = NULL;
            //NSLog( @">>>Boss Bob_x:%f Bob_y:%f Boss_x:%f Boss_y:%f I:%d",_bob.position.x,_bob.position.y,_boss[i].position.x,_boss[i].position.y,i);
        }
    } // for life 0
    
    //NSLog(@"Life : %d",life);
    
} // checkHit


-(void)print{ //檢查Node用
    for (int i=0;i<NUM_BUBBLE;i++){
        NSLog(@"Bubble %@",_bubble[i]);
    }
    for (int i =0;i<NUM_jellyfish;i++){
        NSLog(@"jellyfish %@",_jellyfish[i]);
    }
    for (int i=0;i<NUM_BOSS;i++){
        NSLog(@"Boss %@",_boss[i]);
    }
}


-(void)nowStageNum{
    if([pConnectToSBstage.text isEqualToString:@"1"]){
        now_bubble = 1;
        now_jellyfish = 0;
        now_boss = 0;
    }
    else if([pConnectToSBstage.text isEqualToString:@"2"]){
        now_bubble = 2;
        now_jellyfish = 2;
        now_boss = 0;
    }
    else if([pConnectToSBstage.text isEqualToString:@"3"]){
        now_bubble = 3;
        now_jellyfish = 4;
        now_boss = 1;
    }
    else if([pConnectToSBstage.text isEqualToString:@"4"]){
        now_bubble = 4;
        now_jellyfish = 6;
        now_boss = 2;
    }
    else if([pConnectToSBstage.text isEqualToString:@"5"]){
        now_bubble = 0;
        now_jellyfish = 8;
        now_boss = 3;
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    
    
    /*
    NSLog( @"update: ");
    NSLog( pConnectToSBstage.text);
     */
    [self nextstage];
    [self checkLife];
    [self nowStageNum];
    [self checkHit] ;
    
    
    // Called before each frame is rendered
    
    
    if (!down && count == 0)
        [self checkPosition];
//    if (count == 0)
//        [self checkPosition];
    
    /*
    NSLog(@"Update Pos: %f",_bob.position.y - _bob.size.height/2);
    NSLog(@"Update Life: %d",life);
    NSLog(@"Update Count: %d",count);
    */
    
    //NSLog(@"%@", pConnectToSBstage.text);
    
    if (touch_count == 0)
        pConnectToSBstage.text = @"Touch screen to START";
    
    
    /*
    NSLog(@"Last: %@",lastStage);
    NSLog(@"Now: %@",pConnectToSBstage.text);
    NSLog(@"Life: %d",life);
    */
    
    
    //[self print];
    
}


@end
