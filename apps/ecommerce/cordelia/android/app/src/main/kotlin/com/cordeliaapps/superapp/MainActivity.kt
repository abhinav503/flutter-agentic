package com.cordeliaapps.superapp

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity, not FlutterActivity: flutter_stripe's PaymentSheet
// is presented as a DialogFragment and needs a FragmentActivity host. Flutter
// itself works identically either way.
class MainActivity : FlutterFragmentActivity()
