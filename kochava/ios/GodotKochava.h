//
//  GodotKochava.h
//
//  Created by Vasiliy on 13.05.19.
//
//

#ifndef GodotKochava_h
#define GodotKochava_h

#include "core/object.h"

class GodotKochava : public Object {
    GDCLASS(GodotKochava, Object);

    static void _bind_methods();

public:
    GodotKochava();
    ~GodotKochava();

    void init(const String& key);
    void sendEvent(const String& event);
    void sendEventWithParam(const String& event, const String& param);
    void sendEventWithParams(const String& event, const Dictionary& params);
    void sendStandardEvent(int eventId);
    void sendStandardEventWithParam(int eventId, const String& params);
    void sendStandardEventWithParams(int eventId, const Dictionary& params);

};

#endif /* GodotKochava_h */
