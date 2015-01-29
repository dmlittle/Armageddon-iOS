//
//  SKSpriteNode+Character.m
//  Armagedon
//
//  Created by Donald Little on 1/11/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import "Character.h"

@implementation Character

-(instancetype)initWithTemplateNamed: (NSString *) name  {
    
    NSString *characterName = [NSString stringWithFormat:@"%@_left_0", name];
    
    if (self = [super initWithImageNamed:characterName]) {
        
        // Load character parameters
        self.characterType = name;
        self.walkDirection = @"left";
        self.walkingMargin = 15;
        self.walkingDistance = 345;
        self.frameDuration = 0.15;
        self.walkingSpeed = 50;
        
        // Set physics body
        [self updatePhysicsBody];

        // Initiate at random location
        int xPos = rand()%345+15;
        int yPos = rand()%50+75;
        
        [self setPosition:CGPointMake(xPos, yPos)];
        [self setZPosition:-yPos];
        
        // Load animation textures
        NSMutableArray *leftTextures = [NSMutableArray arrayWithCapacity:4];
        NSMutableArray *rightTextures = [NSMutableArray arrayWithCapacity:4];
        
        for (int i = 0; i <= 3; i++) {
            leftTextures[i] = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_left_%d", name, i]];
            rightTextures[i] = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_right_%d", name, i]];
        }
        
        self.walkLeft = [SKAction animateWithTextures:leftTextures timePerFrame:self.frameDuration];
        self.walkRight = [SKAction animateWithTextures:rightTextures timePerFrame:self.frameDuration];
    }
    
    [self setNextDestination];

    return self;

}


-(void)setNextDestination {
    float relativeLocation = (self.position.x - self.walkingMargin) / self.walkingDistance;
    double xPos = self.position.x;

    int newX;

    if (relativeLocation < 0.5) {
        // Character is in the first third of the screen
        newX = rand()%125+235;
    } else {
        // Character is in the last third of the screen
        newX = rand()%125+15;
    }
    
    double dX = (newX - xPos);
    double dt = abs(dX) / self.walkingSpeed;
    int animationCount = (int) dt / (self.frameDuration * 4);
    
    SKAction *moveAction = [SKAction moveToX:newX duration:dt];
    
    SKAction *groupAction;
    
    if (newX - xPos > 0) {
        self.walkDirection = @"right";
        groupAction = [SKAction group:@[moveAction, [SKAction repeatAction:self.walkRight count:animationCount]]];
    } else {
        self.walkDirection = @"left";
        groupAction = [SKAction group:@[moveAction, [SKAction repeatAction:self.walkLeft count:animationCount]]];
    }
    
    [self updatePhysicsBody];
    [self runAction:groupAction completion:^{
        [self setNextDestination];
    }];
}

-(void)updatePhysicsBody {
    
    SKTexture *tmpTexture;
    
    if ([self.walkDirection isEqualToString:@"right"]) {
        tmpTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_right_0", self.characterType]];
    } else {
        tmpTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_left_0", self.characterType]];
    }
}

@end
