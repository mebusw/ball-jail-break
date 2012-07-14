//
//  Obstacles.h
//  ball-jail-break
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface Obstacles : NSObject {
    b2World *_world;
}

-(id) initWithWorld:(b2World*) world;
-(b2Fixture*) newSensor:(b2Vec2) vec2;


@end
