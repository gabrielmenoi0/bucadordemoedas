import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  /// package que possibilita o armazenamento usando o cache do dispositivo
  final _storage = const FlutterSecureStorage();

  /// função para escrever dados
  Future writeSecureData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  /// função para ler dados
  Future readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  /// função para deletar dados
  Future deleteSecureData(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

  /// função para verificar exstencia de dados
  Future containsSecureData(String key) async {
    var readData = await _storage.containsKey(key: key);
    return readData;
  }
}
