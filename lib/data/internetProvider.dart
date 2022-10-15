import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  /// variavel de internet
  bool _isOnline = false;
  bool get isOnline => _isOnline;
  /// classe que observa a internet em tempo real
  ConnectivityProvider() {
    Connectivity _connectivity = Connectivity();
    /// observador lintener de internet do package Connectivity
    _connectivity.onConnectivityChanged.listen((result) async {
      _isOnline = result == ConnectivityResult.none ? false : true;
      /// atualização do estado da aplicação
      notifyListeners();
    });
  }
}