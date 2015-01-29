//
//  GameScene.m
//  Armagedon
//
//  Created by Donald Little on 1/10/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import "GameScene.h"
#import "Character.h"
#import "Arrow.h"
#import "Snake.h"
#import "StartGameLayer.h"
#import "TutorialGameLayer.h"
#import "GameOverLayer.h"

#import <AVFoundation/AVFoundation.h>


@interface GameScene() <StartGameLayerDelegate, TutorialGameLayerDelegate, GameOverLayerDelegate>
{
    
    BOOL _gameStarted;
    BOOL _gamePaused;
    BOOL _gameOver;
    
    StartGameLayer* _startGameLayer;
    TutorialGameLayer* _tutorialGameLayer;
    GameOverLayer* _gameOverLayer;
    
    SKLabelNode *_gameScore;
    SKLabelNode *_pauseButton;

    int _score;
    
    NSMutableArray *_characters;
    NSMutableArray *_arrows;
    
    AVAudioPlayer *_backgroundMusicPlayer;


}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self setupCloudAnimation];
    [self setupMusic];
    [self setupNewGame];
    [self showStartGameLayer];
}

-(void)setupCloudAnimation {
    self.physicsWorld.contactDelegate = (id)self;
    
    _gamePaused = NO;
    
    NSArray *moveBigClouds = @[
                               [SKAction moveBy:CGVectorMake(-1300, 0) duration:24],
                               [SKAction moveBy:CGVectorMake(1300, 0) duration:0],
                               ];
    
    NSArray *moveSmallClouds = @[
                                 [SKAction moveBy:CGVectorMake(-1300, 0) duration:48],
                                 [SKAction moveBy:CGVectorMake(1300, 0) duration:0],
                                 ];
    
    SKSpriteNode *bigCloudsNode = (SKSpriteNode *)[self childNodeWithName:@"bigClouds"];
    SKSpriteNode *smallCloudsNode = (SKSpriteNode *)[self childNodeWithName:@"smallClouds"];
    
    [bigCloudsNode runAction:[SKAction repeatActionForever:[SKAction sequence:moveBigClouds]]];
    [smallCloudsNode runAction:[SKAction repeatActionForever:[SKAction sequence:moveSmallClouds]]];
}

-(void)setupMusic
{
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"arabesqueSounds" withExtension:@"wav"];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _backgroundMusicPlayer.numberOfLoops = -1;
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];

}

-(void)setPausedState:(BOOL) state
{
    self.view.paused = state;
    self.scene.paused = state;
    _gamePaused = state;
}

-(void)setupNewGame {
    // Initialize helper arrays
    if (_arrows) {
        for (Arrow *a in _arrows.copy) {
            [a removeFromParent];
            [_arrows removeObject:a];
        }
    }
    
    if (_characters) {
        for (Arrow *c in _characters.copy) {
            [c removeFromParent];
            [_characters removeObject:c];
        }
    }

    _arrows = [NSMutableArray new];
    _characters = [NSMutableArray new];
    
    [self addInitialCharacters];
    [self initializeStartGameLayer];
    [self initializeTutorialGameLayer];
    [self initializeGameOverLayer];

}

-(void)addInitialCharacters
{
    for (int i = 0; i < 4; i++) {
        [self addNewCharacterWithName:@"boy"];
    }
    
    [self addNewCharacterWithName:@"queen"];
    [self addNewCharacterWithName:@"girl"];
 
}

-(void)addNewCharacterWithName:(NSString *)spriteName {
    Character *newCharacter = [[Character alloc] initWithTemplateNamed:spriteName];
    [_characters addObject:newCharacter];
    [self addChild:newCharacter];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGFloat touchXPos = location.x;
        CGFloat touchYPos = location.y;
        
        if([_pauseButton containsPoint:location])
        {
            if (_gamePaused) {
                [self setPausedState:NO];
                _gamePaused = NO;
            } else {
                [self setPausedState:YES];
                _gamePaused = YES;
            }
        }
        
        if (_gameStarted & !_gamePaused) {
            for (Arrow *arrow in _arrows.copy) {
                
                CGFloat xPos = arrow.position.x;
                CGFloat yPos = arrow.position.y;
                
                if (abs(xPos - touchXPos) < 35 && abs(yPos - touchYPos) < 40) {
                    [_arrows removeObject:arrow];
                    [arrow removeFromParent];
                    _score++;
                    [self refreshScoreLabel];
                    
                    if ( ( _score % 50) == 0 && _score > 0) {
                        int randomNum = arc4random() % 7 == 0;
                        if (randomNum == 0) {
                            [self addNewCharacterWithName:@"jawa"];
                        } else if (randomNum == 1) {
                            [self addNewCharacterWithName:@"queen"];
                        } else if (randomNum == 2) {
                            [self addNewCharacterWithName:@"girl"];
                        } else {
                            [self addNewCharacterWithName:@"boy"];
                        }
                        Snake *tmpSnake = [[Snake alloc] initWithTemplateNamed:@"snake"];
                        [self addChild:tmpSnake];

                    }
                    
                }
            }
            
        }
    }
    
}

#pragma mark -Initialize Helper Layers
-(void)initializeGameButtons
{
    if (!_gameScore) {
        _gameScore = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [_gameScore setName:@"scoreLabel"];
        [_gameScore setFontSize:40];
        [_gameScore setZPosition:50];
        [_gameScore setText:@"0"];
        [_gameScore setPosition:CGPointMake(self.size.width - (20 + _gameScore.frame.size.width/2), self.size.height - (30 + _gameScore.frame.size.height/2))];
        [self addChild:_gameScore];
    }
    
    if (!_pauseButton) {
        _pauseButton = [[SKLabelNode alloc] initWithFontNamed:@"Papyrus"];
        [_pauseButton setName:@"pauseButton"];
        [_pauseButton setFontSize:20];
        [_pauseButton setZPosition:50];
        [_pauseButton setText:@"▌▌"];
        [_pauseButton setPosition:CGPointMake((10 + _pauseButton.frame.size.width/2), self.size.height - (20 + _pauseButton.frame.size.height/2))];
        [self addChild:_pauseButton];
    }
}

-(void)removeGameButtons
{
    [_gameScore removeFromParent];
    [_pauseButton removeFromParent];
    _gameScore = nil;
    _pauseButton = nil;
    
}

- (void) initializeStartGameLayer
{
    _startGameLayer = [[StartGameLayer alloc]initWithSize:self.size];
    _startGameLayer.userInteractionEnabled = YES;
    _startGameLayer.zPosition = 999;
    _startGameLayer.delegate = self;
}

- (void) initializeTutorialGameLayer
{
    _tutorialGameLayer = [[TutorialGameLayer alloc]initWithSize:self.size];
    _tutorialGameLayer.userInteractionEnabled = YES;
    _tutorialGameLayer.zPosition = 999;
    _tutorialGameLayer.delegate = self;
}


- (void)initializeGameOverLayer
{
    _gameOverLayer = [[GameOverLayer alloc]initWithSize:self.size];
    _gameOverLayer.userInteractionEnabled = YES;
    _gameOverLayer.zPosition = 999;
    _gameOverLayer.delegate = self;
}

#pragma mark - GameStatus calls
- (void) showStartGameLayer
{
    [_tutorialGameLayer removeFromParent];
    [_gameOverLayer removeFromParent];
    [self removeGameButtons];
    [self addChild:_startGameLayer];
}

- (void) showTutorialGameLayer
{
    [_startGameLayer removeFromParent];
    [_gameOverLayer removeFromParent];
    [self removeGameButtons];
    [self addChild:_tutorialGameLayer];
}



- (void) showGameOverLayer
{
    _gameOver = YES;
    _gameStarted = NO;

    [self addChild:_gameOverLayer];
}

#pragma mark - Delegates
#pragma mark -StartGameLayer
- (void)startGameLayer:(StartGameLayer *)sender tapRecognizedOnButton:(StartGameLayerButtonType)startGameLayerButton
{
    _gameOver = NO;
    _gameStarted = YES;
    
    [self showTutorialGameLayer];
}

- (void)tutorialGameLayer:(TutorialGameLayer *)sender tapRecognizedOnButton:(TutorialGameLayerButtonType)startGameLayerButton
{
    _gameOver = NO;
    _gameStarted = YES;
    
    [self startGame];
}


- (void)gameOverLayer:(GameOverLayer *)sender tapRecognizedOnButton:(GameOverLayerButtonType)gameOverLayerButtonType
{
    _gameOver = NO;
    _gameStarted = NO;
    
    if (gameOverLayerButtonType == GameOverLayerHomeButton) {
        [self showStartGameLayer];
        [self addInitialCharacters];
    } else if (gameOverLayerButtonType == GameOverLayerPlayButton) {
        [_gameOverLayer removeFromParent];
        [self setupNewGame];
        [self startGame];
    }
}

- (void)startGame
{
    _score = 0;
    [self initializeGameButtons];
    [self refreshScoreLabel];
    
    _gameStarted = YES;

    [_startGameLayer removeFromParent];
    [_tutorialGameLayer removeFromParent];
    [_gameOverLayer removeFromParent];
    
}

-(void)refreshScoreLabel
{
    [_gameScore setText:[NSString stringWithFormat:@"%u", _score]];
}

#pragma mark - Update Score


-(void)removeObjectFromParent: (SKSpriteNode *) character {
    
    [character removeFromParent];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    if (_gameStarted) {
        if ( rand()%100 < 5 ) {
            Arrow *arrow = [Arrow new];
            [_arrows addObject:arrow];
            [self addChild:arrow];
        }
        
        if ([_characters count] == 0) {
            _gameStarted = NO;
            for (Arrow *a in [_arrows copy]) {
                [a removeFromParent];
                [_arrows removeObject:a];
            }
           
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *savedBestScore = [defaults objectForKey:@"bestScore"];
            NSNumber *currentScore = [NSNumber numberWithInt:_score];
            
            [defaults setObject:currentScore forKey:@"lastScore"];
            if ([currentScore intValue] > [savedBestScore intValue]) {
                [defaults setObject:currentScore forKey:@"bestScore"];
            }
            [defaults synchronize];
            
            [self initializeGameOverLayer];
            [self showGameOverLayer];
            
        }

    
        for (Arrow *a in [_arrows copy]) {
            if (a.position.y < 125) {
                [a explode];
                [_arrows removeObject:a];
                for (Character *c in _characters.copy) {
                    if ([a targetCharacterInsideExplosion:c]) {
                        [_characters removeObject:c];
                        [self performSelector:@selector(removeObjectFromParent:) withObject:c afterDelay:0.25];
                    }
                }
            }
        }
        
    }
    
    
}


@end
