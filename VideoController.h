//
//  VideoController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 25/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoController : BaseController

@property (nonatomic, strong) MPMoviePlayerController *player;

@property (nonatomic, strong) UIActivityIndicatorView *mIndicator;

@end
