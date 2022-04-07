//
//  Card.h
//  playCard
//
//  Created by IraShinking on 2022/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject

@property(strong,nonatomic) NSString *contents;
@property(nonatomic,getter=isChosen) BOOL chosen;
@property(nonatomic,getter=isMatched) BOOL matched;

@end

NS_ASSUME_NONNULL_END
