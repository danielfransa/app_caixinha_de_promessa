import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/promise.dart';

class PromisesRepository {
  final Random _random;

  PromisesRepository({Random? random}) : _random = random ?? Random();

  Future<List<Promise>> loadPromises() async {
    final jsonString = await rootBundle.loadString('assets/data/promessas.json');
    final jsonList = json.decode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => Promise.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<Promise> filterByLanguage({
    required List<Promise> promises,
    required String language,
  }) {
    return promises.where((promise) => promise.language == language).toList();
  }

  Promise getRandomPromise(List<Promise> promises) {
    final index = _random.nextInt(promises.length);
    return promises[index];
  }
}
