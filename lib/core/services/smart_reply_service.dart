// Conditional import
export 'smart_reply_service_mobile.dart'
    if (dart.library.html) 'smart_reply_service_web.dart';
