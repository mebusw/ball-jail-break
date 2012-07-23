//
//  Levels.h
//  ball-jail-break
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


class Levels {
private:
    b2World *m_world;
    
public:
    Levels(b2World *world) {
        m_world = world;
    }
    
    ~Levels() {
        m_world = NULL;
    }
    
    void level1() {
        
    }
};


