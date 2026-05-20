/// App-wide constants. Keeping IDs / keys in one place avoids drift
/// between zone trackers, recovery contexts and analytics.
class AppConstants {
  static const String appName = 'Morph Shop';

  // Demo license key — points at the FREE tier so the Pro features
  // print upgrade hints in debug logs but never block the UI.
  static const String morphLicenseKey = 'cha-pro-25877f582362';

  // MorphZone IDs used on the home screen — must stay stable so the
  // scorer's history survives reorders.
  static const String zoneFeatured = 'home_featured';
  static const String zoneCategories = 'home_categories';
  static const String zoneTrending = 'home_trending';
  static const String zoneRecent = 'home_recent';

  // Workflow id stem for the multi-step checkout. The screen tags it
  // with a timestamp so each fresh checkout gets its own chain.
  static const String checkoutWorkflowPrefix = 'checkout';
}
