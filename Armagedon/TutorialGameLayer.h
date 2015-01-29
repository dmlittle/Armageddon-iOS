//
//  SKNode+TutorialGameLayer.h
//  Armagedon
//
//  Created by Donald Little on 1/29/15.
//  Copyright (c) 2015 Little Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameHelperLayer.h"

typedef NS_ENUM(NSUInteger, TutorialGameLayerButtonType)
{
    TutorialGameLayerPlayButton = 0
};


@protocol TutorialGameLayerDelegate;
@interface TutorialGameLayer : GameHelperLayer
@property (nonatomic, assign) id<TutorialGameLayerDelegate> delegate;
@end


//**********************************************************************
@protocol TutorialGameLayerDelegate <NSObject>
@optional

- (void) tutorialGameLayer:(TutorialGameLayer*)sender tapRecognizedOnButton:(TutorialGameLayerButtonType) startGameLayerButton;
@end