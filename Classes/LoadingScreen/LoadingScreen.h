//
//  LoadingScreen.h
//  iLove
//
//  Created by Codewalla on 09/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadingScreenDelegate;

@interface LoadingScreen : UIViewController {
	id<LoadingScreenDelegate> delegate;
}

@property (nonatomic, assign) id<LoadingScreenDelegate> delegate;
- (void) callAnotherScreen;

@end

@protocol LoadingScreenDelegate

- (void) loadingScreenTapped;

@end

