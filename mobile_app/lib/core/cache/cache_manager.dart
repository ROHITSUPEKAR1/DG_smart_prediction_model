import 'dart:convert';
import 'package:hive/hive.dart';

/// Centralized cache manager for offline-first data access.
/// Uses Hive for high-performance local NoSQL storage.
///
/// Pattern: fetch-first, cache-fallback.
/// - On network success → serialize response → store locally.
/// - On network failure → return cached version transparently.
class CacheManager {
  static const String _boxName = 'dg_smart_cache';
  static Box? _box;

  /// Initialize Hive box. Must be called after Hive.initFlutter().
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Store serializable data under a key.
  static Future<void> put(String key, dynamic data) async {
    final box = _box ?? await Hive.openBox(_boxName);
    await box.put(key, jsonEncode(data));
  }

  /// Retrieve cached data by key. Returns null if not found.
  static T? get<T>(String key) {
    final box = _box;
    if (box == null) return null;
    final raw = box.get(key);
    if (raw == null) return null;
    return jsonDecode(raw) as T;
  }

  /// Remove a specific cache entry.
  static Future<void> invalidate(String key) async {
    final box = _box ?? await Hive.openBox(_boxName);
    await box.delete(key);
  }

  /// Clear all cached data (e.g., on logout).
  static Future<void> clearAll() async {
    final box = _box ?? await Hive.openBox(_boxName);
    await box.clear();
  }
}
