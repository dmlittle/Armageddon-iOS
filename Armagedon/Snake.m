//
//  SKNode+Snake.m
//  Armagedon
//
//  Created by Donald Little on 1/29/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import "Snake.h"

@implementation Snake

-(instancetype)initWithTemplateNamed: (NSString *) name  {
    
    NSString *characterName = [NSString stringWithFormat:@"%@_left_0", name];
    
    if (self = [super initWithImageNamed:characterName]) {
        
        // Load character parameters
        self.characterType = name;
        self.walkDirection = @"left";
        self.walkingMargin = 15;
        self.walkingDistance = 345;
        self.frameDuration = 0.15;
        self.walkingSpeed = 30;
        
        // Set physics body
        [self updatePhysicsBody];
        
        // Initiate at random location
        int xPos = 380;
        int yPos = 150;
        
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
    double xPos = self.position.x;
    
    int newX = -20;
    
    double dX = (newX - xPos);
    double dt = abs(dX) / self.walkingSpeed;
    int animationCount = (int) dt / (self.frameDuration * 4);
    
    SKAction *moveAction = [SKAction moveToX:newX duration:dt];
    SKAction *moveUp = [SKAction moveBy:CGVectorMake(0, 30) duration:dt];
    
    SKAction *groupAction = [SKAction group:@[moveAction, moveUp, [SKAction repeatAction:self.walkLeft count:animationCount]]];
    
    [self updatePhysicsBody];
    [self runAction:groupAction completion:^{
        [self removeFromParent];
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
