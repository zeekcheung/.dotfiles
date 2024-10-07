// Disable telemetry and data collection
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("beacon.enabled", false);

// Enable userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Enable hardware acceleration
user_pref("layers.acceleration.force-enabled", true);

// Disable pocket
user_pref("extensions.pocket.enabled", false);

// Disable fullscreen autohide
user_pref("browser.fullscreen.autohide", false);
