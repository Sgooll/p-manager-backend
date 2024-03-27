import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

sealed class EncryptService {
  static Future<String> encodeRSA(String text) async {
    final keys = await _getKeys();

    final public = keys.$1;
    final private = keys.$2;

    final encrypter = Encrypter(RSA(publicKey: public, privateKey: private));

    final encripted = encrypter.encrypt(text);

    return encripted.base64;
  }

  static Future<String> decodeRSA(String encodedStr) async {
    final keys = await _getKeys();

    final public = keys.$1;
    final private = keys.$2;

    final encrypter = Encrypter(RSA(publicKey: public, privateKey: private));

    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encodedStr));

    return decrypted;
  }

  static Future<(RSAPublicKey, RSAPrivateKey)> _getKeys() async {
    final publicKey = await parseKeyFromFile<RSAPublicKey>('public.pem');
    final privKey = await parseKeyFromFile<RSAPrivateKey>('private.pem');

    return (publicKey, privKey);
  }
}
