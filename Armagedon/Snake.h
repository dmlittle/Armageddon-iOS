//
//  SKNode+Snake.h
//  Armagedon
//
//  Created by Donald Little on 1/29/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Snake: SKSpriteNode

@property (strong, nonatomic) SKAction *walkLeft;
@property (strong, nonatomic) SKAction *walkRight;
@property (strong, nonatomic) NSString *walkDirection;
@property (strong, nonatomic) NSString *characterType;
@property (nonatomic) int walkingMargin;
@property (nonatomic) int walkingDistance;
@property (nonatomic) int walkingSpeed;
@property (nonatomic) double frameDuration;

-(instancetype)initWithTemplateNamed: (NSString *) name;
-(void)setNextDestination;

@end
