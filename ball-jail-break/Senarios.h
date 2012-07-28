//
//  Senarios.h
//  ball-jail-break
//
//  Created by  on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Obstacles.h"
#import "Senarios.h"

@interface Senarios : NSObject {
    b2World *_world;
    Obstacles *_obstacles;
}


-(id) initWithBuilder:(Obstacles*)obstacles world:(b2World*)world;
-(void) senario_1WithTimer:(float32*)timer fail:(b2Fixture**)sensor_fail win:(b2Fixture**)sensor_win;

@end
