//
//  CollMovieCell.h
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/8/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollMovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
