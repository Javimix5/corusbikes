import 'package:flutter/material.dart';
import '../models/station.dart';
import '../services/stations_service.dart';

class StationsViewModel extends ChangeNotifier {
  final StationsService _stationsService;

  StationsViewModel({StationsService? stationsService}) : _stationsService = stationsService ?? StationsService();

  List<Station> _stations = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  bool _showOnlyFavorites = false;

  List<Station> get stations {
    List<Station> filteredStations = _stations;
    
    if (_showOnlyFavorites) {
      filteredStations = filteredStations.where((s) => s.isFavorite).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filteredStations = filteredStations.where((s) => 
        s.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filteredStations;
  }
  
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get showOnlyFavorites => _showOnlyFavorites;
  String get searchQuery => _searchQuery;

  Future<void> fetchStations({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _stations = await _stationsService.fetchStations(forceRefresh: forceRefresh);
    } catch (e) {
      _errorMessage = "Error de conexión: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setStations(List<Station> stations) {
    _stations = stations;
    notifyListeners();
  }

  Future<void> refreshStations() async {
    await fetchStations(forceRefresh: true);
  }

  void toggleFavorite(String stationId) {
    final index = _stations.indexWhere((s) => s.id == stationId);
    if (index != -1) {
      _stations[index].isFavorite = !_stations[index].isFavorite;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void toggleFavoritesFilter() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }

  int get favoritesCount => _stations.where((s) => s.isFavorite).length;
}