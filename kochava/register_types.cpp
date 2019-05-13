#include "register_types.h"
#if defined(__APPLE__)
#include "ios/GodotKochava.h"
#endif

void register_kochava_types() {
#if defined(__APPLE__)
	ClassDB::register_class<GodotKochava>();
#endif
}

void unregister_kochava_types() {
}
