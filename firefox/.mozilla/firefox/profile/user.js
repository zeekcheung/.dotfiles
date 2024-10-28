// Enable custom stylesheets (userChrome.css)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Keep toolbar visible in fullscreen
user_pref("browser.fullscreen.autohide", false);

// Disable pocket extension
user_pref("extensions.pocket.enabled", false);

// Disable accessibility
user_pref("accessibility.force_disabled", 1);

// Disable captive portal detection
user_pref("network.captive-portal-service.enabled", false);

// Disable checking for proxies
user_pref("network.notify.checkForProxies", false);

// Disable network separations
user_pref("fission.autostart", false);
user_pref("privacy.partition.network_state", false);

// Faster SSL
user_pref("network.ssl_tokens_cache_capacity", 32768);

// Reduce the number of processes
user_pref("dom.ipc.processCount", 1);
user_pref("dom.ipc.processCount.webIsolated", 1);

// Limit the memory cache size to 512MB
user_pref("browser.cache.memory.capacity", 512000);

// Increase predictive network operations
user_pref("network.dns.disablePrefetchFromHTTPS", false);
user_pref("network.dnsCacheEntries", 20000);
user_pref("network.dnsCacheExpiration", 3600);
user_pref("network.dnsCacheExpirationGracePeriod", 240);
user_pref("network.predictor.enable-hover-on-ssl", true);
user_pref("network.predictor.enable-prefetch", true);
user_pref("network.predictor.preconnect-min-confidence", 20);
user_pref("network.predictor.prefetch-force-valid-for", 3600);
user_pref("network.predictor.prefetch-min-confidence", 30);
user_pref("network.predictor.prefetch-rolling-load-count", 120);
user_pref("network.predictor.preresolve-min-confidence", 10);

// GFX rendering tweaks
user_pref("gfx.canvas.accelerated", true);
user_pref("gfx.canvas.accelerated.cache-items", 32768);
user_pref("gfx.canvas.accelerated.cache-size", 4096);
user_pref("layers.acceleration.force-enabled", false);
user_pref("gfx.content.skia-font-cache-size", 80);
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.compositor", true);
user_pref("gfx.webrender.compositor.force-enabled", true);
user_pref("gfx.webrender.enabled", true);
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.webrender.program-binary-disk", true);
user_pref("gfx.webrender.software.opengl", true);
user_pref("image.mem.decode_bytes_at_a_time", 65536);
user_pref("image.mem.shared.unmap.min_expiration_ms", 120000);
user_pref("layers.gpu-process.enabled", true);
user_pref("layers.gpu-process.force-enabled", true);
user_pref("image.cache.size", 10485760);
user_pref("media.memory_cache_max_size", 1048576);
user_pref("media.memory_caches_combined_limit_kb", 3145728);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("media.ffmpeg.vaapi.enabled", true);

// Smooth scrolling
user_pref("general.smoothScroll.lines.durationMaxMS", 125);
user_pref("general.smoothScroll.lines.durationMinMS", 125);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.other.durationMaxMS", 125);
user_pref("general.smoothScroll.other.durationMinMS", 125);
user_pref("general.smoothScroll.pages.durationMaxMS", 125);
user_pref("general.smoothScroll.pages.durationMinMS", 125);
user_pref("mousewheel.min_line_scroll_amount", 30);
user_pref("mousewheel.system_scroll_override_on_root_content.enabled", true);
user_pref("mousewheel.system_scroll_override_on_root_content.horizontal.factor", 175);
user_pref("mousewheel.system_scroll_override_on_root_content.vertical.factor", 175);
user_pref("toolkit.scrollbox.horizontalScrollDistance", 6);
user_pref("toolkit.scrollbox.verticalScrollDistance", 2);

