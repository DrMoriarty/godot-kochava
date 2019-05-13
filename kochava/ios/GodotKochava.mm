//
//  GodotKochava.mm
//
//  Created by Vasiliy on 13.05.19.
//
//

#import <Foundation/Foundation.h>
#import "./GodotKochava.h"
#import <libKochavaTrackeriOS/KochavaTracker.h>

NSDictionary *convertFromDictionary(const Dictionary& dict)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for(int i=0; i<dict.size(); i++) {
        Variant key = dict.get_key_at_index(i);
        Variant val = dict.get_value_at_index(i);
        if(key.get_type() == Variant::STRING) {
            NSString *strKey = [NSString stringWithUTF8String:((String)key).utf8().ptr()];
            if(val.get_type() == Variant::INT) {
                int i = (int)val;
                result[strKey] = @(i);
            } else if(val.get_type() == Variant::REAL) {
                double d = (double)val;
                result[strKey] = @(d);
            } else if(val.get_type() == Variant::STRING) {
                NSString *s = [NSString stringWithUTF8String:((String)val).utf8().ptr()];
                result[strKey] = s;
            } else if(val.get_type() == Variant::BOOL) {
                BOOL b = (bool)val;
                result[strKey] = @(b);
            } else if(val.get_type() == Variant::DICTIONARY) {
                NSDictionary *d = convertFromDictionary((Dictionary)val);
                result[strKey] = d;
            } else {
                ERR_PRINT("Unexpected type as dictionary value");
            }
        } else {
            ERR_PRINT("Non string key in Dictionary");
        }
    }
    return result;
}

GodotKochava::GodotKochava()
{
}

GodotKochava::~GodotKochava()
{
}

void GodotKochava::init(const String& key) {
    NSString *appKey = [NSString stringWithUTF8String:key.utf8().ptr()];
    [KochavaTracker.shared configureWithParametersDictionary:@{kKVAParamAppGUIDStringKey: appKey} delegate:nil];
}

void GodotKochava::sendEvent(const String& event) {
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().ptr()];
    [KochavaTracker.shared sendEventWithNameString:eventName infoString:nil];
}

void GodotKochava::sendEventWithParam(const String& event, const String& param) {
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().ptr()];
    NSString *str = [NSString stringWithUTF8String:(param).utf8().ptr()];
    [KochavaTracker.shared sendEventWithNameString:eventName infoString:str];
}

void GodotKochava::sendEventWithParams(const String& event, const Dictionary& params) {
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().ptr()];
    NSDictionary *dict = convertFromDictionary(params);
    [KochavaTracker.shared sendEventWithNameString:eventName infoDictionary:dict];
}

void GodotKochava::sendStandardEvent(int eventId) {
    if(eventId < 100 || eventId > 118) {
        ERR_PRINT("Invalid standard event Id");
    }
    KochavaEvent *event = [KochavaEvent eventWithEventTypeEnum:(KochavaEventTypeEnum)eventId];
    [KochavaTracker.shared sendEvent:event];
}

void GodotKochava::sendStandardEventWithParam(int eventId, const String& param) {
    if(eventId < 100 || eventId > 118) {
        ERR_PRINT("Invalid standard event Id");
    }
    KochavaEvent *event = [KochavaEvent eventWithEventTypeEnum:(KochavaEventTypeEnum)eventId];
    NSString *str = [NSString stringWithUTF8String:(param).utf8().ptr()];
    event.infoString = str;
    [KochavaTracker.shared sendEvent:event];
}

void GodotKochava::sendStandardEventWithParams(int eventId, const Dictionary& params) {
    if(eventId < 100 || eventId > 118) {
        ERR_PRINT("Invalid standard event Id");
    }
    KochavaEvent *event = [KochavaEvent eventWithEventTypeEnum:(KochavaEventTypeEnum)eventId];
    NSDictionary *dict = convertFromDictionary(params);
    event.infoDictionary = dict;
    [KochavaTracker.shared sendEvent:event];
}

void GodotKochava::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("init", "key"), &GodotKochava::init);
    ClassDB::bind_method(D_METHOD("event", "name"), &GodotKochava::sendEvent);
    ClassDB::bind_method(D_METHOD("event_with_param", "name", "param"), &GodotKochava::sendEventWithParams);
    ClassDB::bind_method(D_METHOD("event_with_params", "name", "params"), &GodotKochava::sendEventWithParams);
    ClassDB::bind_method(D_METHOD("standard_event", "eventId"), &GodotKochava::sendStandardEvent);
    ClassDB::bind_method(D_METHOD("standard_event_with_param", "eventId", "param"), &GodotKochava::sendStandardEventWithParams);
    ClassDB::bind_method(D_METHOD("standard_event_with_params", "eventId", "params"), &GodotKochava::sendStandardEventWithParams);
}
