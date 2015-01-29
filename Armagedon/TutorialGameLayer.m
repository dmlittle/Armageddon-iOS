
//
//  SKNode+TutorialGameLayer.m
//  Armagedon
//
//  Created by Donald Little on 1/29/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//


#import "TutorialGameLayer.h"

@interface TutorialGameLayer()
@property (nonatomic, retain) SKSpriteNode* playButton;
@end


@implementation TutorialGameLayer

- (id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        
        SKLabelNode *howToPlayLabel = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [howToPlayLabel setFontSize:47];
        [howToPlayLabel setText:@"HOW TO PLAY"];
        [howToPlayLabel setPosition:CGPointMake(size.width * 0.5f, size.height * 0.8f)];
        [self addChild:howToPlayLabel];
        
        SKLabelNode *instructionLabel1 = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [instructionLabel1 setFontSize:25];
        [instructionLabel1 setPosition:CGPointMake(size.width * 0.5f, size.height * 0.7f)];
        [instructionLabel1 setText:@"Tap & destroy all arrows"];
        [self addChild:instructionLabel1];
        
        SKLabelNode *instructionLabel2 = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [instructionLabel2 setFontSize:25];
        [instructionLabel2 setPosition:CGPointMake(size.width * 0.5f, size.height * 0.65f)];
        [instructionLabel2 setText:@"Don't let the arrows explode"];
        [self addChild:instructionLabel2];
        
        SKLabelNode *instructionLabel3 = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [instructionLabel3 setFontSize:25];
        [instructionLabel3 setPosition:CGPointMake(size.width * 0.5f, size.height * 0.26f)];
        [instructionLabel3 setText:@"Can you save 'em?"];
        [self addChild:instructionLabel3];


        SKSpriteNode* tutorialImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutImage"];
        tutorialImage.position = CGPointMake(size.width * 0.5f, size.height * 0.47f);
        [self addChild:tutorialImage];
        
        SKSpriteNode* playButton = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
        [playButton setSize:CGSizeMake(playButton.size.width/3, playButton.size.height/3)];
        playButton.position = CGPointMake(size.width * 0.5f, size.height * 0.15f);
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
        if([self.delegate respondsToSelector:@selector(tutorialGameLayer:tapRecognizedOnButton:)])
        {
            [self.delegate tutorialGameLayer:self tapRecognizedOnButton:TutorialGameLayerPlayButton];
        }
    }
}
@end
