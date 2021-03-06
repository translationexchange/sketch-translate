//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSCloudPreferencesViewController.h"

@class NSButton, NSProgressIndicator;

@interface MSCloudPreferencesIntroViewController : MSCloudPreferencesViewController
{
    NSButton *_learnMoreButton;
    NSProgressIndicator *_progressIndicator;
    NSButton *_loginButton;
}

@property(retain, nonatomic) NSButton *loginButton; // @synthesize loginButton=_loginButton;
@property(retain, nonatomic) NSProgressIndicator *progressIndicator; // @synthesize progressIndicator=_progressIndicator;
@property(retain, nonatomic) NSButton *learnMoreButton; // @synthesize learnMoreButton=_learnMoreButton;
- (void).cxx_destruct;
- (void)cloudAPILoggingInDidChangeNotification:(id)arg1;
- (void)learnMore:(id)arg1;
- (void)login:(id)arg1;
- (void)signup:(id)arg1;
- (void)dealloc;
- (void)viewDidLoad;

@end

