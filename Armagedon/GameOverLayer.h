//
//  SKNode+GameOverLayer.h
//  Armagedon
//
//  Created by Donald Little on 1/28/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameHelperLayer.h"

typedef NS_ENUM(NSUInteger, GameOverLayerButtonType)
{
    GameOverLayerHomeButton = 0,
    GameOverLayerPlayButton = 1
};


@protocol GameOverLayerDelegate;
@interface GameOverLayer : GameHelperLayer

@property (nonatomic, assign) id<GameOverLayerDelegate> delegate;

@end


//**********************************************************************
@protocol GameOverLayerDelegate <NSObject>
@optional

- (void) gameOverLayer:(GameOverLayer*)sender tapRecognizedOnButton:(GameOverLayerButtonType) gameOverLayerButtonType;
@end