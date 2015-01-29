//
//  SKNode+StartGameLayer.h
//  Armagedon
//
//  Created by Donald Little on 1/28/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameHelperLayer.h"

typedef NS_ENUM(NSUInteger, StartGameLayerButtonType)
{
    StartGameLayerPlayButton = 0
};


@protocol StartGameLayerDelegate;
@interface StartGameLayer : GameHelperLayer
@property (nonatomic, assign) id<StartGameLayerDelegate> delegate;
@end


//**********************************************************************
@protocol StartGameLayerDelegate <NSObject>
@optional

- (void) startGameLayer:(StartGameLayer*)sender tapRecognizedOnButton:(StartGameLayerButtonType) startGameLayerButton;
@end