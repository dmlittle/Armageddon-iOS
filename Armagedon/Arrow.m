//
//  SKSpriteNode+Arrow.m
//  Armagedon
//
//  Created by Donald Little on 1/12/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import "Arrow.h"
#import <AVFoundation/AVFoundation.h>

static int arrowCount = 0;

@implementation Arrow

+(int)arrowCount
{
    return arrowCount++;
    
}

-(instancetype)init  {
    if (self = [super initWithImageNamed:@"arrow"]) {
        
        self.zPosition = 100;
        
        // Initiate at random location
        CGFloat xPosition;
        
        // Testing new random locations based on the amount of arrows created...
        int arrowCount = [Arrow arrowCount];
        
        if (arrowCount < 15) {
            xPosition = 50 + 137 * arc4random_uniform(3);
        } else if (arrowCount < 50) {
            xPosition = 50 + 92 * arc4random_uniform(4);
        } else {
            xPosition = 50 + 69 * arc4random_uniform(5);
        }
        
        [self setPosition:CGPointMake(xPosition, 800)];
        
        // Load animation textures
        NSMutableArray *explosionTextures = [NSMutableArray arrayWithCapacity:16];
        
        for (int i = 0; i < 16; i++) {
            explosionTextures[i] = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion_%d", i]];
        }
        
        self.explosionAnimation = [SKAction group:@[
                                                    [SKAction animateWithTextures:explosionTextures timePerFrame:0.078125],
                                                    [SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:NO],
                                                    [SKAction moveByX:0 y:-32 duration:0]
                                                    ]];
        
        // Set physics body
        CGSize size = CGSizeMake(self.texture.size.width, self.texture.size.height);        
        self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = arrowMask;
        self.physicsBody.contactTestBitMask = characterMask;
        self.physicsBody.collisionBitMask = characterMask;
        self.physicsBody.fieldBitMask = 0;

    }
    
    return self;
    
}

-(BOOL)targetCharacterInsideExplosion: (Character *) character {
    
    CGFloat explosionPos = self.position.x;
    CGFloat charPos = character.position.x;
    
    if (abs(charPos - explosionPos) <= 64) {
        return YES;
    }
    
    return NO;
}

-(void)explode {
    self.size = [SKTexture textureWithImageNamed:@"explosion_0"].size;
    self.physicsBody = nil;
    self.zPosition = 999;
    
    [self runAction:self.explosionAnimation completion:^{
        [self removeFromParent];
    }];
    
}

@end
