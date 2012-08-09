//
//  Senarios.m
//  ball-jail-break
//
//  Created by  on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Senarios.h"
#import "Box2D.h"
#import "Obstacles.h"

@implementation Senarios

-(id) initWithBuilder:(Obstacles*)obstacles world:(b2World*)world {
    if (self = [super init]) {
        _world = world;
        _obstacles = obstacles;
    }
    return self;


}

-(void) senario_1WithTimer:(float32*)timer fail:(b2Fixture**)sensor_fail win:(b2Fixture**)sensor_win  {
    
    //        CCSprite *blackHole = [CCSprite spriteWithFile:@"blackHole.png"];
    //        [self addChild:blackHole];
    *sensor_fail = _obstacles->newStar(b2Vec2(1, 6), .6f, NULL, b2Vec2(.12f, 0), 0);
    *sensor_win = _obstacles->newStar(b2Vec2(4, 7), .6f, NULL, b2Vec2(0, 0), 0);
    
    _obstacles->newStaticField(b2Vec2(1, .1f), b2Vec2(5, 3), .1f * b2_pi, NULL);
    _obstacles->newStaticField(b2Vec2(1, .1f), b2Vec2(6.5, 3), -.1f * b2_pi, NULL);
    _obstacles->newStaticField(b2Vec2(1.5, .1f), b2Vec2(10.5, 3.2), .13f * b2_pi, NULL);
    _obstacles->newStaticField(b2Vec2(.5f, .5f), b2Vec2(7, 5), 0.2f * b2_pi, NULL);
    
    
    for (int i = 0; i<50;i++) {
        _obstacles->newTriangleStaticField(b2Vec2(.5f, .5f), b2Vec2(9.3f, 5), 0.35f * b2_pi, NULL);
        
    }
    _obstacles->newTriangleStaticField(b2Vec2(.5f, .5f), b2Vec2(9.3f, 5), 0.35f * b2_pi, NULL);
    _obstacles->newTriangleStaticField(b2Vec2(.5f, .5f), b2Vec2(3, 7.5), 0.25f * b2_pi, NULL);
    _obstacles->newTriangleStaticField(b2Vec2(.5f, .5f), b2Vec2(12, 5.5), 0.75f * b2_pi, NULL);
    _obstacles->newTriangleStaticField(b2Vec2(.6f, .6f), b2Vec2(6, 7.5), 0.85f * b2_pi, NULL);
    
    _obstacles->newSpaceRobot(b2Vec2(.6f, .1f), b2Vec2(.6f, .1f), b2Vec2(2.5, 4), b2Vec2(2, 4.2), 0, -0.95 * b2_pi, .95 * b2_pi, 1.5, NULL, NULL);
    _obstacles->newSpaceRobot(b2Vec2(.2f, .2f), b2Vec2(.8f, .1f), b2Vec2(8, 4), b2Vec2(8, 4.2), 0, -0.15 * b2_pi, .95 * b2_pi, 1.2, NULL, NULL);
    _obstacles->newSpaceRobot(b2Vec2(.2f, .2f), b2Vec2(.8f, .1f), b2Vec2(12, 7), b2Vec2(12, 7), 0, -0.15 * b2_pi, .95 * b2_pi, 3.2, NULL, NULL);
    _obstacles->newSpaceRobot(b2Vec2(.1f, .1f), b2Vec2(.8f, .1f), b2Vec2(10, 7.2), b2Vec2(10, 7.2), 0, -0.15 * b2_pi, .95 * b2_pi, -3.2, NULL, NULL);
    
    for (int i = 0; i < 100; i++) {
        _obstacles->newWaterDrop(.05f, b2Vec2(5, 1), NULL)->ApplyForce(b2Vec2(0.5, -0.1), b2Vec2(10, 10));
    }
    
    
    
    *timer = 1000;
}

-(void) senario_2WithTimer:(float32*)timer fail:(b2Fixture**)sensor_fail win:(b2Fixture**)sensor_win  {
    
}

@end
