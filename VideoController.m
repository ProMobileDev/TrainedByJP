//
//  VideoController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 25/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "VideoController.h"

@interface VideoController ()

@end

@implementation VideoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *fileURL = [NSURL URLWithString:[ApiManager sharedInstance].url];
    
     self.player = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [self.player.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     self.player.controlStyle = MPMovieControlStyleFullscreen;
     self.player.fullscreen = YES;
    [self.player play];
    //self.player.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.view addSubview:self.player.view];
    
    self.mIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.mIndicator.center = self.view.center;
    [self.view addSubview:self.mIndicator];
    
    [self shouldAutorotate];
    [self.mIndicator startAnimating];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    [self hideTabBar:self.tabBarController];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppDelegate *app = ((AppDelegate *) [[UIApplication sharedApplication] delegate]);
    app.isVideoController = NO;

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *app = ((AppDelegate *) [[UIApplication sharedApplication] delegate]);
    app.isVideoController = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceOrientationLandscape) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
}

-(void)doneButtonClick:(NSNotification*)aNotification
{
    [self.navigationController popViewControllerAnimated:YES];
    [self showTabBar:self.tabBarController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    [super shouldAutorotate];
    return YES;
}

- (void)forceOrientationLandscape
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft];
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void) hideTabBar:(UITabBarController *) tabbarcontroller
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    float fHeight = screenRect.size.height;
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
            view.backgroundColor = [UIColor blackColor];
        }
    }
    [UIView commitAnimations];
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float fHeight = screenRect.size.height - tabbarcontroller.tabBar.frame.size.height;    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
        }
    }
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notif
{
    if (self.player.loadState & MPMovieLoadStateStalled)
    {
        [self.mIndicator startAnimating];
        [self.player pause];
    }
    else if (self.player.loadState & MPMovieLoadStatePlaythroughOK)
    {
        [self.mIndicator stopAnimating];
        [self.player play];
    }
}

- (void)moviePlayerPlaybackFinished:(NSNotification *)notif
{
    [self.player.view removeFromSuperview];
    [self.mIndicator stopAnimating];
}


@end
