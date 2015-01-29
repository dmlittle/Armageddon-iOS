//
//  SKNode+StartGameLayer.m
//  Armagedon
//
//  Created by Donald Little on 1/28/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import "StartGameLayer.h"

@interface StartGameLayer()
@property (nonatomic, retain) SKSpriteNode* playButton;
@end


@implementation StartGameLayer

- (id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        [[self childNodeWithName:@"transparent"] removeFromParent];
        
        SKSpriteNode* startGameText = [SKSpriteNode spriteNodeWithImageNamed:@"logo"];
        startGameText.position = CGPointMake(size.width * 0.5f, size.height * 0.8f);
        [self addChild:startGameText];
        
        SKSpriteNode* playButton = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
        playButton.position = CGPointMake(size.width * 0.5f, size.height * 0.60f);
        [self addChild:playButton];
        
        [self setPlayButton:playButton];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([_playButton containsPoint:location])
    {
        if([self.delegate respondsToSelector:@selector(startGameLayer:tapRecognizedOnButton:)])
        {
            [self.delegate startGameLayer:self tapRecognizedOnButton:StartGameLayerPlayButton];
        }
    }
}
@end
