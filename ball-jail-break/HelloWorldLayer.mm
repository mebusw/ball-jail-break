//
//  HelloWorldLayer.mm
//  ball-jail-break
//
//  Created by  on 12-7-8.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameOverLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32


// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
    kMenuFail = 100,
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, 1.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		

		//****************//
		
		// Define the ground body.
        [self addGround];
		
		//Set up sprite
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		[self addChild:batch z:0 tag:kTagBatchNode];
		
        //_obstacles = [[Obstacles alloc] initWithWorld:world];
        _obstacles = new Obstacles(world);
        
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Cross Galaxy" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
		
        [self setupMenus];
        
        [self setupSenario];
        [self addBall:ccp(240, 10)];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf" loop:YES];
        
        NSArray *starsArray = [NSArray arrayWithObjects:@"Stars1.plist", @"Stars2.plist", @"Stars3.plist", nil];
        for(NSString *stars in starsArray) {        
            CCParticleSystemQuad *starsEffect = [CCParticleSystemQuad particleWithFile:stars];        
            [self addChild:starsEffect z:1];
        }
        
        //********************//

        
		[self schedule: @selector(tick:)];
	}
	return self;
}


- (void) setupMenus {
    {
        /////Pause Menu////
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"||" fontName:@"Marker Felt" fontSize:22];
        CCMenuItemLabel *itmStart = [CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            CCLOG(@"in || block");
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:itmStart, nil];
        menu.position = ccp(460, 300);
        [self addChild:menu];
        
    }
    
    
    {
        //////Fail Menu/////
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Play Again" fontName:@"Marker Felt" fontSize:32];
        CCMenuItemLabel *itmStart = [CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            CCLOG(@"in restart block");
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:itmStart, nil];
        menu.position = ccp(240, 200);
        menu.tag = kMenuFail;
        menu.visible = NO;
        [self addChild:menu];
    }
    
    ////// Timer Label ////
    timerLabel = [CCLabelTTF labelWithString:@"00:000" fontName:@"Marker Felt" fontSize:24];
    timerLabel.position = ccp(50, 300);
    [self addChild:timerLabel];
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}


-(void) setupSenario {
   
    CCSprite *blackHole = [CCSprite spriteWithFile:@"blackHole.png"];
    [self addChild:blackHole];
    sensor_fail = _obstacles->newStar(b2Vec2(1, 6), .6f, blackHole, b2Vec2(.12f, 0), 0);
    sensor_win = _obstacles->newStar(b2Vec2(4, 7), .6f, NULL, b2Vec2(0, 0), 0);

    _obstacles->newStaticField(b2Vec2(1, .1f), b2Vec2(5, 3), .1f * b2_pi, NULL);
    _obstacles->newStaticField(b2Vec2(1, .1f), b2Vec2(6.5, 3), -.1f * b2_pi, NULL);
    _obstacles->newStaticField(b2Vec2(1.5, .1f), b2Vec2(10.5, 3.2), .13f * b2_pi, NULL);
    _obstacles->newStaticField(b2Vec2(.5f, .5f), b2Vec2(7, 5), 0.2f * b2_pi, NULL);
    
    _obstacles->newTriangleStaticField(b2Vec2(.5f, .5f), b2Vec2(9.3f, 5), 0.35f * b2_pi, NULL);
    _obstacles->newTriangleStaticField(b2Vec2(.5f, .5f), b2Vec2(3, 7.5), 0.25f * b2_pi, NULL);
    _obstacles->newTriangleStaticField(b2Vec2(.5f, .5f), b2Vec2(12, 5.5), 0.75f * b2_pi, NULL);
    _obstacles->newTriangleStaticField(b2Vec2(.6f, .6f), b2Vec2(6, 7.5), 0.85f * b2_pi, NULL);
    
    _obstacles->newSpaceRobot(b2Vec2(.6f, .1f), b2Vec2(.6f, .1f), b2Vec2(2.5, 4), b2Vec2(2, 4.2), 0, -0.95 * b2_pi, .95 * b2_pi, 1.5, NULL, NULL);
    _obstacles->newSpaceRobot(b2Vec2(.2f, .2f), b2Vec2(.8f, .1f), b2Vec2(8, 4), b2Vec2(8, 4.2), 0, -0.15 * b2_pi, .95 * b2_pi, 1.2, NULL, NULL);
    _obstacles->newSpaceRobot(b2Vec2(.2f, .2f), b2Vec2(.8f, .1f), b2Vec2(12, 7), b2Vec2(12, 7), 0, -0.15 * b2_pi, .95 * b2_pi, 3.2, NULL, NULL);
    _obstacles->newSpaceRobot(b2Vec2(.1f, .1f), b2Vec2(.8f, .1f), b2Vec2(10, 7.2), b2Vec2(10, 7.2), 0, -0.15 * b2_pi, .95 * b2_pi, -3.2, NULL, NULL);
    
    
    timer = 1000;

}

-(void) addGround {
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    ground = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;		
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // bottom
    groundBox.SetAsEdge(b2Vec2(0, 0), b2Vec2(screenSize.width/PTM_RATIO, 0));
    ground->CreateFixture(&groundBox,0);
    
    // top
    groundBox.SetAsEdge(b2Vec2(0, screenSize.height/PTM_RATIO - 1.5f), b2Vec2(screenSize.width/PTM_RATIO, screenSize.height/PTM_RATIO - 1.5f));
    ground->CreateFixture(&groundBox,0);
    
    // left
    groundBox.SetAsEdge(b2Vec2(0, 0), b2Vec2(0, screenSize.height/PTM_RATIO));
    ground->CreateFixture(&groundBox,0);
    
    // right
    groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,0), b2Vec2(screenSize.width/PTM_RATIO, screenSize.height/PTM_RATIO));
    ground->CreateFixture(&groundBox,0);
    
}



-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
    sprite.tag = 55;
	[batch addChild:sprite];
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;

	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
}


-(void) addObstacles:(CGPoint)p {
    CCLOG(@"");
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
    
    int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[batch addChild:sprite];
	
	sprite.position = ccp( p.x, p.y);
	
	b2BodyDef bodyDef;
	//bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
    
	body->CreateFixture(&dynamicBox, 0);
    
}

-(void) addBall:(CGPoint)p {
    CCLOG(@"");
//    CCSprite *ballSp = [CCSprite spriteWithFile:@"ball32.png"];
    CCSprite *ballSp = [CCSprite spriteWithFile:@"ufo.png"];
    ballSp.tag = 99;
    [self addChild:ballSp];
    
    ballSp.position = ccp(p.x, p.y + 20);
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(p.x/PTM_RATIO, (p.y + 20)/PTM_RATIO);
    ballBodyDef.userData = ballSp;
    b2Body *ballBody = world->CreateBody(&ballBodyDef);
    
    b2CircleShape ballBox;
    ballBox.m_radius = .5f;
    
    b2FixtureDef ballFixtureDef;
    ballFixtureDef.shape = &ballBox;
    ballFixtureDef.density = .8f;
    ballFixtureDef.friction = 0.4f;
    ballFixtureDef.restitution = .3f;
    ball = ballBody->CreateFixture(&ballFixtureDef);
        
}


-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
    
    
    if ([self checkStar:sensor_fail] || [self checkStar:sensor_win] || timer <= 0) {
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).timeRemains = [NSNumber numberWithFloat:timer];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[GameOverLayer scene]]];
    } 
    
    //update timer
    timer -= dt;
    [timerLabel setString:[NSString stringWithFormat:@"%2.3f", timer]];
}

-(bool) checkStar:(b2Fixture*) star {
    for (b2Contact* c = world->GetContactList(); c; c = c->GetNext()) {
        if (c->IsTouching() && c->GetFixtureA() == star) {
            //CCSprite *actor = (CCSprite*)c->GetFixtureB()->GetBody()->GetUserData();
            return (ball == c->GetFixtureB());
            //CCLOG(@"%@ %d %d", actor, actor.tag, c->GetFixtureA()->IsSensor()); 
        } else if (c->IsTouching() && c->GetFixtureB() == star) {
            return (ball == c->GetFixtureA());
            //CCSprite *actor = (CCSprite*)c->GetFixtureA()->GetBody()->GetUserData();
            //CCLOG(@"%@ %d %d", actor, actor.tag, c->GetFixtureB()->IsSensor()); 
        }
    }
    return false;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteWithCoords: location];
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 0.05f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	//b2Vec2 gravity( -accelY * 10, accelX * 10);
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	ccDeviceOrientation dr = (ccDeviceOrientation)orientation;
    
    if (dr == UIDeviceOrientationLandscapeLeft) {
        b2Vec2 gravity( -accelY * 10, 1);
        world->SetGravity( gravity );
    } else if (dr == UIDeviceOrientationLandscapeRight) {
        b2Vec2 gravity( accelY * 10, 1);
        world->SetGravity( gravity );
    }
	


}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
    //[_obstacles dealloc];
    delete _obstacles;
    
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
