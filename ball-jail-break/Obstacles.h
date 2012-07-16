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

class Ob {
public:
    Ob(b2World *world) {
        m_world = world;
    }
    
    ~Ob() {
        m_world = NULL;
    }
    
    /**
     * add new star as sensor
     */
    b2Fixture* newStar(b2Vec2 vec2) {
        b2BodyDef bodyDef;
        bodyDef.position.Set(vec2.x, vec2.y);
        b2Body *body = m_world->CreateBody(&bodyDef);
        
        
        b2CircleShape holeDef;
        holeDef.m_radius = .6f;
        b2FixtureDef holeFixtureDef;
        holeFixtureDef.shape = &holeDef;
        holeFixtureDef.isSensor = true;
        return body->CreateFixture(&holeFixtureDef); 
    }
    
private:
    b2World *m_world;
};

@end
