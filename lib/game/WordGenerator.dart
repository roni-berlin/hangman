import 'dart:math';

class WordGenerator {

  static List<String> category = ['🍔', '🦁'];

  static List<List<String>> words = [
    ['המבורגר', 'פיצה'],
    ['פרה', 'תרנגול']
  ];

  static String wordGen(int category) {
    var rng = new Random();
    return words[category][rng.nextInt(words.length)];
  }
}
