import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  /// 초기화 메서드 - main.dart에서 호출
  Future<StorageService> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      return this;
    } catch (e) {
      throw Exception('StorageService 초기화 실패: $e');
    }
  }

  // ==================== String 관련 ====================
  
  /// 문자열 저장
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      Get.snackbar('저장 오류', 'String 저장 실패: $e');
      return false;
    }
  }

  /// 문자열 읽기
  String? readString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      Get.snackbar('읽기 오류', 'String 읽기 실패: $e');
      return null;
    }
  }

  // ==================== Bool 관련 ====================
  
  /// Boolean 저장
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      Get.snackbar('저장 오류', 'Bool 저장 실패: $e');
      return false;
    }
  }

  /// Boolean 읽기
  bool? readBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      Get.snackbar('읽기 오류', 'Bool 읽기 실패: $e');
      return null;
    }
  }

  // ==================== Int 관련 ====================
  
  /// 정수 저장
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      Get.snackbar('저장 오류', 'Int 저장 실패: $e');
      return false;
    }
  }

  /// 정수 읽기
  int? readInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      Get.snackbar('읽기 오류', 'Int 읽기 실패: $e');
      return null;
    }
  }

  // ==================== 삭제 ====================
  
  /// 특정 키 삭제
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      Get.snackbar('삭제 오류', 'Key 삭제 실패: $e');
      return false;
    }
  }

  /// 모든 데이터 삭제
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      Get.snackbar('삭제 오류', '전체 삭제 실패: $e');
      return false;
    }
  }

  // ==================== 유틸리티 ====================
  
  /// 키 존재 여부 확인
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  /// 모든 키 가져오기
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}
