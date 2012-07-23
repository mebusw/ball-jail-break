//
//  GameOverLayer.mm
//  ball-jail-break
//
//  Created by  on 12-7-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"

@implementation GameOverLayer


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height - 80 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        [self setupMenus];
        
        [self scheduleUpdate];
	}
	return self;
}

-(void) setupMenus {

    float timeRemains = [((AppDelegate*)[[UIApplication sharedApplication] delegate]).timeRemains floatValue];
    CCLOG(@"%f", timeRemains);
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %.0f", timeRemains * 10.0f] fontName:@"Marker Felt" fontSize:32];
    scoreLabel.position = ccp(240, 100);
    [self addChild:scoreLabel];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Play Again" fontName:@"Marker Felt" fontSize:32];
    CCMenuItemLabel *itmStart = [CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        CCLOG(@"in restart block");
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
    }];
    CCMenu *menu = [CCMenu menuWithItems:itmStart, nil];
    menu.position = ccp(240, 200);
    menu.visible = YES;
    [self addChild:menu];
}


-(void) update: (ccTime) dt {
}

@end
