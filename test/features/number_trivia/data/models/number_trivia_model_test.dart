import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_study/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_study/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late NumberTriviaModel sut;

  setUp(() {
    sut = const NumberTriviaModel(number: 1, text: 'Test text');
  });

  test('should be a subclass of NumberTrivia', () {
    // assert
    expect(sut, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () {
      // arange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, sut);
    });

    test(
        'should return a valid model when the JSON number is regarded as a double',
        () {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, sut);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      // act
      final result = sut.toJson();

      // assert
      final expectedMap = {
        "text": "Test text",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}
