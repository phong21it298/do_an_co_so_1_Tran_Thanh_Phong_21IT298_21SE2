import 'package:flutter/material.dart';
import '../model/local/search_history.dart';
import '../services/anime_database_helper.dart';

class SearchHistoryViewModel extends ChangeNotifier {
  final AnimeDatabaseHelper _dbHelper = AnimeDatabaseHelper();
  List<SearchHistory> _histories = [];

  List<SearchHistory> get histories => _histories;

  //Lấy danh sách lịch sử.
  Future<void> loadHistories(int userId) async {
    _histories = await _dbHelper.getHistoryByUserId(userId);
    //print("Histories loaded: ${_histories.length}");
    notifyListeners();
  }

  //Xóa lịch sử được chọn.
  Future<void> deleteHistory(int id) async {
    await _dbHelper.deleteSearchHistory(id);
    _histories.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  //Chỉnh sửa lịch sử được chọn.
  Future<void> updateHistory(SearchHistory updated) async {
    await _dbHelper.updateSearchHistory(updated);
    int index = _histories.indexWhere((h) => h.id == updated.id);
    if (index != -1) {
      _histories[index] = updated;
      notifyListeners();
    }
  }
}
