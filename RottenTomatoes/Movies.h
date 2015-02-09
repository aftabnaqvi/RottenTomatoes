//
//  Movies.h
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/7/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSString *BASE_URL = @"http://api.rottentomatoes.com/api/public/v1.0";
static const NSString *API_KEY = @"rvjna6c6k3mwutfn9hfqmaza";

//static const UIColor* lightPurpleColor = [UIColor colorWithRed:205.0f/255.0f
//				green:153.0f/255.0f
//				 blue:255.0f/255.0f
//				alpha:1.0f];

@interface Movies : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSString *url;
@end
