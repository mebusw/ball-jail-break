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


class Obstacles {
private:
    b2World *m_world;
    
public:
    Obstacles(b2World *world) {
        m_world = world;
    }
    
    ~Obstacles() {
        m_world = NULL;
    }
    
    /**
     * add new star as sensor
     * meteor: lineVelocity > 0
     * planet: motorSpeed > 0
     */
    b2Fixture* newStar(b2Vec2 pos, float32 radius, void *sprite, b2Vec2 lineVelocity, float32 motorSpeed) {
        b2BodyDef bodyDef;
        bodyDef.position.Set(pos.x, pos.y);
        bodyDef.userData = sprite;
        bodyDef.type = b2_kinematicBody;
        bodyDef.linearVelocity = lineVelocity;
        //TODO motorSpeed
        
        b2Body *body = m_world->CreateBody(&bodyDef);
        
        b2CircleShape circleDef;
        circleDef.m_radius = radius;
        
        b2FixtureDef holeFixtureDef;
        holeFixtureDef.shape = &circleDef;
        holeFixtureDef.isSensor = true;
        return body->CreateFixture(&holeFixtureDef);
    }
    
    /**
     * add static field as static body
     */
    b2Body* newStaticField(b2Vec2 size, b2Vec2 pos, float32 angle, void *sprite) {
        b2BodyDef bodyDef;
        bodyDef.position.Set(pos.x, pos.y);
        bodyDef.userData = sprite;
        bodyDef.angle = angle;
        b2Body *body = m_world->CreateBody(&bodyDef);
        
        b2PolygonShape boxDef;
        boxDef.SetAsBox(size.x, size.y);
        
        body->CreateFixture(&boxDef, 0);
        return body;
    }
    
    /**
     * add triangle static field as static body
     */
    b2Body* newTriangleStaticField(b2Vec2 size, b2Vec2 pos, float32 angle, void *sprite) {
        b2BodyDef bodyDef;
        bodyDef.position.Set(pos.x, pos.y);
        bodyDef.userData = sprite;
        bodyDef.angle = angle;
        b2Body *body = m_world->CreateBody(&bodyDef);
        
        b2PolygonShape triangleDef;
        b2Vec2 vertices[3];
        vertices[0].Set(0, size.y);
        vertices[1].Set(-size.x / 2, 0);
        vertices[2].Set(size.x / 2, 0);
        triangleDef.Set(vertices, 3);
        
        body->CreateFixture(&triangleDef, 0);
        return body;
    }
    
    
    /**
     * add space robot as revolute joint
     * A is fixed, B can revolute
     */
    b2RevoluteJoint* newSpaceRobot(b2Vec2 sizeA, b2Vec2 sizeB, b2Vec2 posA, b2Vec2 posB, float32 angleA, float32 lowerAngleB, float32 upperAngleB, float32 motorSpeed, void *spriteA, void *spriteB) {
        b2BodyDef bodyDef;
        
        bodyDef.position.Set(posA.x, posA.y);
        bodyDef.userData = spriteA;
        bodyDef.type = b2_staticBody;
        bodyDef.angle = angleA;
        b2Body *bodyA = m_world->CreateBody(&bodyDef);
        
        bodyDef.position.Set(posB.x, posB.y);
        bodyDef.userData = spriteB;
        bodyDef.type = b2_dynamicBody;
        b2Body *bodyB = m_world->CreateBody(&bodyDef);        
        
        
        b2PolygonShape boxDef;
        
        boxDef.SetAsBox(sizeA.x, sizeA.y);
        bodyA->CreateFixture(&boxDef, 0);
        
        boxDef.SetAsBox(sizeB.x, sizeB.y);
        bodyB->CreateFixture(&boxDef, 12);
        
        
        b2RevoluteJointDef jd;
        jd.Initialize(bodyA, bodyB, bodyA->GetWorldCenter());
        jd.lowerAngle = lowerAngleB;
        jd.upperAngle = upperAngleB;
        jd.motorSpeed = motorSpeed;
        jd.maxMotorTorque = 100;
        //jd.enableLimit = true;
        jd.enableMotor = true;
        return (b2RevoluteJoint*)m_world->CreateJoint(&jd);
    }

};


