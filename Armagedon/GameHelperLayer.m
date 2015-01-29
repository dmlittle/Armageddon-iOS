//
//  SKNode+GameHelper.m
//  Armagedon
//
//  Created by Donald Little on 1/28/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import "GameHelperLayer.h"

@implementation GameHelperLayer

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self)
    {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:0.0 alpha:0.8] size:size];
        node.anchorPoint = CGPointZero;
        [self addChild:node];
        node.zPosition = -1;
        node.name = @"transparent";
    }
    return self;
}

@end
