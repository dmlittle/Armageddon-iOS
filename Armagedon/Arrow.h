//
//  SKSpriteNode+Arrow.h
//  Armagedon
//
//  Created by Donald Little on 1/12/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ObjectMasks.h"
#import "Character.h"

@interface Arrow: SKSpriteNode

@property (strong, nonatomic) SKAction *explosionAnimation;

-(BOOL)targetCharacterInsideExplosion: (Character *) character;
-(void)explode;

@end
