//
//  Obstacles.m
//  ball-jail-break
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Obstacles.h"


@implementation Obstacles



-(id) initWithWorld:(b2World*) world {
    if (self = [super init]) {
        _world = world;
    }
    
    return self;
}

-(void) dealloc {
    _world = nil;
    [super dealloc];
    
}


/**
 * add new star as sensor
 */
-(b2Fixture*) newSensor:(b2Vec2) vec2 {
    b2BodyDef bodyDef;
    bodyDef.position.Set(vec2.x, vec2.y);
    b2Body *body = _world->CreateBody(&bodyDef);
    
    
    b2CircleShape holeDef;
    holeDef.m_radius = .6f;
    b2FixtureDef holeFixtureDef;
    holeFixtureDef.shape = &holeDef;
    holeFixtureDef.isSensor = true;
    return body->CreateFixture(&holeFixtureDef); 
}








@end
