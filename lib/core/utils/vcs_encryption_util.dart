import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class VcsEncryptionUtil {
  static const _keyLength = 32;
  static const _ivLength = 16;

  final String _secretKey;

  VcsEncryptionUtil(this._secretKey);

  String encrypt(String plainText) {
    final key = _deriveKey();
    final iv = _generateIv();
    final encrypted = _xorEncrypt(utf8.encode(plainText), key, iv);
    final combined = Uint8List.fromList(iv + encrypted);
    return base64Encode(combined);
  }

  String decrypt(String cipherText) {
    final key = _deriveKey();
    final combined = base64Decode(cipherText);
    final iv = combined.sublist(0, _ivLength);
    final encrypted = combined.sublist(_ivLength);
    final decrypted = _xorEncrypt(encrypted, key, iv);
    return utf8.decode(decrypted);
  }

  Uint8List _deriveKey() {
    final keyBytes = utf8.encode(_secretKey);
    if (keyBytes.length >= _keyLength) {
      return Uint8List.fromList(keyBytes.sublist(0, _keyLength));
    }
    final padded = Uint8List(_keyLength);
    padded.setAll(0, keyBytes);
    return padded;
  }

  Uint8List _generateIv() {
    final random = Random.secure();
    return Uint8List.fromList(
        List.generate(_ivLength, (_) => random.nextInt(256)));
  }

  Uint8List _xorEncrypt(List<int> data, Uint8List key, Uint8List iv) {
    final result = Uint8List(data.length);
    for (var i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length] ^ iv[i % iv.length];
    }
    return result;
  }
}
