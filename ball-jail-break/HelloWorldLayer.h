//
//  HelloWorldLayer.h
//  ball-jail-break
//
//  Created by  on 12-7-8.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Obstacles.h"
#import "Senarios.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World *world;
    b2Body *ground;

	GLESDebugDraw *m_debugDraw;
    b2Fixture *sensor_fail;
    b2Fixture *sensor_win;
    b2Fixture *ball;
    
    Obstacles *_obstacles;
    Senarios *_senarios;
    
    //timer
    CCLabelTTF *timerLabel;
    float32 timer;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
