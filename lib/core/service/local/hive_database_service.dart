import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabaseService {
  HiveDatabaseService._privateConstructor();
  static final HiveDatabaseService instance =
      HiveDatabaseService._privateConstructor();

  // Belirli bir box açma (Dinamik olarak)
  Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  // Veri ekleme veya güncelleme
  Future<void> putData<T>(String boxName, String key, T value) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await openBox<T>(boxName);
      }
    } catch (e) {
      // Eğer box zaten açılmışsa hata oluşmasını engellemek için
      log("Box zaten açık: $e");
    }
    final box = Hive.box<T>(boxName);
    await box.put(key, value);
  }

  // Veri okuma
  Future<T?> getData<T>(String boxName, String key) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await openBox<T>(boxName);
      }
    } catch (e) {
      // Eğer box zaten açılmışsa hata oluşmasını engellemek için
      log("Box zaten açık: $e");
    }
    final box = Hive.box<T>(boxName);
    return box.get(key);
  }

  // Tüm verileri okuma
  Future<List<T>> getAllData<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await openBox<T>(boxName);
      }
    } catch (e) {
      // Eğer box zaten açılmışsa hata oluşmasını engellemek için
      log("Box zaten açık: $e");
    }
    final box = Hive.box<T>(boxName);
    return box.values.toList();
  }

  // Veri silme
  Future<void> deleteData<T>(String boxName, String key) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await openBox<T>(boxName);
      }
    } catch (e) {
      // Eğer box zaten açılmışsa hata oluşmasını engellemek için
      log("Box zaten açık: $e");
    }
    final box = Hive.box<T>(boxName);
    await box.delete(key);
  }

  // Tüm verileri silme
  Future<void> clearBox<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await openBox<T>(boxName);
      }
    } catch (e) {
      // Eğer box zaten açılmışsa hata oluşmasını engellemek için
      log("Box zaten açık: $e");
    }
    final box = Hive.box<T>(boxName);
    await box.clear();
  }

  // Box'u kapatma
  Future<void> closeBox<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await openBox<T>(boxName);
      }
    } catch (e) {
      // Eğer box zaten açılmışsa hata oluşmasını engellemek için
      log("Box zaten açık: $e");
    }
    final box = Hive.box<T>(boxName);
    await box.close();
  }

  // Tüm box'ları kapatma
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}
