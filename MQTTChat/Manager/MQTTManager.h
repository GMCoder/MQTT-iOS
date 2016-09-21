//
//  MQTTManager.h
//  MQTTChat
//
//  Created by 高明 on 16/9/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(UInt8, QosLevel){
    AtMostOnce = 0,
    AtLeastOnce = 1,
    ExactlyOnce = 2
};

@protocol MQTTManagerDelegate <NSObject>

- (void)receiveMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained;

@end

@interface MQTTManager : NSObject

@property (nonatomic, weak) id <MQTTManagerDelegate> delegate;

+ (instancetype)shareMQTTManager;

- (void)connectToHost;

- (void)disconnectToHost;

- (UInt16)subscribeToTopic:(NSString *)topic atLevel:(QosLevel)level;

- (UInt16)sendMessage:(NSData *)message topic:(NSString *)topic qos:(QosLevel)qos retain:(BOOL)retain;

@end
