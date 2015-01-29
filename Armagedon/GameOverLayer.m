//
//  SKNode+GameOverLayer.m
//  Armagedon
//
//  Created by Donald Little on 1/28/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import "GameOverLayer.h"

@interface GameOverLayer() {
    int _score;
    int _best;
}

@property (nonatomic, retain) SKSpriteNode* homeButton;
@property (nonatomic, retain) SKSpriteNode* retryButton;
@end

@implementation GameOverLayer

- (id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        SKLabelNode *gameOver = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [gameOver setFontSize:45];
        [gameOver setText:@"GAME OVER"];
        [gameOver setPosition:CGPointMake(size.width * 0.5f, size.height * 0.65f)];
        [self addChild:gameOver];
        
        
        SKLabelNode *scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [scoreLabel setName:@"score"];
        [scoreLabel setFontSize:30];
        [scoreLabel setText:[NSString stringWithFormat:@"Score: %@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"lastScore"]]];
        [scoreLabel setPosition:CGPointMake(size.width * 0.5f, size.height * 0.55f)];
        [self addChild:scoreLabel];
        
        
        SKLabelNode *bestScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [scoreLabel setName:@"best"];
        [bestScoreLabel setFontSize:30];
        [bestScoreLabel setText:[NSString stringWithFormat:@"Best: \t %@",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"]]];
        [bestScoreLabel setPosition:CGPointMake(size.width * 0.5f, size.height * 0.55f - bestScoreLabel.frame.size.height*2)];
        [self addChild:bestScoreLabel];


        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home"];
        homeButton.position = CGPointMake(size.width * 0.35f, size.height * 0.30f);
        [self addChild:homeButton];

        SKSpriteNode *retryButton = [SKSpriteNode spriteNodeWithImageNamed:@"replay"];
        retryButton.position = CGPointMake(size.width * 0.65f, size.height * 0.30f);
        [self addChild:retryButton];
        
        [self setHomeButton:homeButton];
        [self setRetryButton:retryButton];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([_retryButton containsPoint:location]){
        
        if([self.delegate respondsToSelector:@selector(gameOverLayer:tapRecognizedOnButton:)])
        {
            [self.delegate gameOverLayer:self tapRecognizedOnButton:GameOverLayerPlayButton];
        }
        
    } else if ([_homeButton containsPoint:location]) {
        
        if([self.delegate respondsToSelector:@selector(gameOverLayer:tapRecognizedOnButton:)])
        {
            [self.delegate gameOverLayer:self tapRecognizedOnButton:GameOverLayerHomeButton];
        }
        
    }
}

@end
