import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as en;
import 'package:flutter/material.dart';
import 'package:onepass/utils/constants.dart';

bool isNullOrEmpty(String string) {
  if (string == null || string.isEmpty)
    return true;
  else
    return false;
}

double displayHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double displayWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Function(String) emptyOrNullStringValidator = (String value) {
  if (isNullOrEmpty(value)) {
    return "Cannot be empty!";
  } else
    return null;
};

Function(String) numberLengthValidator = (String value) {
  if (value.length != 10) {
    return "Invalid Number!";
  } else
    return null;
};

en.Encrypted encrypt(String plainText, String key) {
  final content = Utf8Encoder().convert(key);
  final md5 = crypto.md5;
  final digest = md5.convert(content);
  final md5Key = en.Key.fromUtf8(digest.toString());
  final iv = en.IV.fromLength(16);
  final encrypter = en.Encrypter(en.AES(md5Key));
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted;
}

String decrypt(String encryptedText, String key) {
  final content = Utf8Encoder().convert(key);
  final md5 = crypto.md5;
  final digest = md5.convert(content);
  final md5Key = en.Key.fromUtf8(digest.toString());
  final iv = en.IV.fromLength(16);
  final encrypter = en.Encrypter(en.AES(md5Key));
  try {
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  } catch (e) {}
  return null;

  // encrypter.decrypt(encryptedText, iv: iv);
}

String generate(int length) {
  String pass = '';
  Random random = new Random();
  while (length > 0) {
    int i = random.nextInt(Constants.VECTORS.length);
    pass = pass +
        Constants.VECTORS[i][random.nextInt(Constants.VECTORS[i].length)];
    length--;
  }
  return pass;
}
