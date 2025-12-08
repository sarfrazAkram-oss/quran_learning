import 'package:flutter/foundation.dart';

@immutable
class Para {
  final int number;
  final String name;
  final String subtitle;
  final String arabicLabel;
  final String? pdfAsset;

  const Para({
    required this.number,
    required this.name,
    required this.subtitle,
    required this.arabicLabel,
    this.pdfAsset,
  });
}

const List<Para> paras = [
  Para(
    number: 1,
    name: 'Alif Lam Meem',
    subtitle: 'Para 1',
    arabicLabel: 'جزء ١',
    pdfAsset: 'assets/Colour Coded Quran Juz 01 (1).pdf',
  ),
  Para(
    number: 2,
    name: 'Sayaqool',
    subtitle: 'Para 2',
    arabicLabel: 'جزء ٢',
    pdfAsset: 'assets/Colour Coded Quran Juz 02 (1).pdf',
  ),
  Para(
    number: 3,
    name: 'Tilkal Rusull',
    subtitle: 'Para 3',
    arabicLabel: 'جزء ٣',
    pdfAsset: 'assets/Colour Coded Quran Juz 03.pdf',
  ),
  Para(
    number: 4,
    name: 'Lan Tana Loo',
    subtitle: 'Para 4',
    arabicLabel: 'جزء ٤',
    pdfAsset: 'assets/Colour Coded Quran Juz 04.pdf',
  ),
  Para(
    number: 5,
    name: 'Wal Mohsanat',
    subtitle: 'Para 5',
    arabicLabel: 'جزء ٥',
    pdfAsset: 'assets/Colour Coded Quran Juz 05 (1).pdf',
  ),
  Para(
    number: 6,
    name: 'La Yuhibbullah',
    subtitle: 'Para 6',
    arabicLabel: 'جزء ٦',
    pdfAsset: 'assets/Colour Coded Quran Juz 06.pdf',
  ),
  Para(
    number: 7,
    name: 'Wa Iza Samiu',
    subtitle: 'Para 7',
    arabicLabel: 'جزء ٧',
    pdfAsset: 'assets/Colour Coded Quran Juz 07.pdf',
  ),
  Para(
    number: 8,
    name: 'Wa Lau Annana',
    subtitle: 'Para 8',
    arabicLabel: 'جزء ٨',
    pdfAsset: 'assets/Colour Coded Quran Juz 08.pdf',
  ),
  Para(
    number: 9,
    name: 'Qalal Malao',
    subtitle: 'Para 9',
    arabicLabel: 'جزء ٩',
    pdfAsset: 'assets/Colour Coded Quran Juz 09.pdf',
  ),
  Para(
    number: 10,
    name: 'Wa A\'lamu',
    subtitle: 'Para 10',
    arabicLabel: 'جزء ١٠',
    pdfAsset: 'assets/Colour Coded Quran Juz 10.pdf',
  ),
  Para(
    number: 11,
    name: 'Yatazeroon',
    subtitle: 'Para 11',
    arabicLabel: 'جزء ١١',
    pdfAsset: 'assets/Colour Coded Quran Juz 11.pdf',
  ),
  Para(
    number: 12,
    name: 'Wa Ma Min Da\'abbatin',
    subtitle: 'Para 12',
    arabicLabel: 'جزء ١٢',
    pdfAsset: 'assets/Colour Coded Quran Juz 12.pdf',
  ),
  Para(
    number: 13,
    name: 'Wa Ma Ubrioo',
    subtitle: 'Para 13',
    arabicLabel: 'جزء ١٣',
    pdfAsset: 'assets/Colour Coded Quran Juz 13.pdf',
  ),
  Para(
    number: 14,
    name: 'Rubama',
    subtitle: 'Para 14',
    arabicLabel: 'جزء ١٤',
    pdfAsset: 'assets/Colour Coded Quran Juz 14.pdf',
  ),
  Para(
    number: 15,
    name: 'Subhanallazi Asra',
    subtitle: 'Para 15',
    arabicLabel: 'جزء ١٥',
    pdfAsset: 'assets/Colour Coded Quran Juz 15.pdf',
  ),
  Para(
    number: 16,
    name: 'Qala Alam',
    subtitle: 'Para 16',
    arabicLabel: 'جزء ١٦',
    pdfAsset: 'assets/Colour Coded Quran Juz 16.pdf',
  ),
  Para(
    number: 17,
    name: 'Iqtaraba',
    subtitle: 'Para 17',
    arabicLabel: 'جزء ١٧',
    pdfAsset: 'assets/Colour Coded Quran Juz 17.pdf',
  ),
  Para(
    number: 18,
    name: 'Qadd Aflaha',
    subtitle: 'Para 18',
    arabicLabel: 'جزء ١٨',
    pdfAsset: 'assets/Colour Coded Quran Juz 18.pdf',
  ),
  Para(
    number: 19,
    name: 'Wa Qalallazina',
    subtitle: 'Para 19',
    arabicLabel: 'جزء ١٩',
    pdfAsset: 'assets/Colour Coded Quran Juz 19.pdf',
  ),
  Para(
    number: 20,
    name: 'A\'man Khalaq',
    subtitle: 'Para 20',
    arabicLabel: 'جزء ٢٠',
    pdfAsset: 'assets/Colour Coded Quran Juz 20.pdf',
  ),
  Para(
    number: 21,
    name: 'Utlu Ma Oohi',
    subtitle: 'Para 21',
    arabicLabel: 'جزء ٢١',
    pdfAsset: 'assets/Colour Coded Quran Juz 21.pdf',
  ),
  Para(
    number: 22,
    name: 'Wa Manyaqnut',
    subtitle: 'Para 22',
    arabicLabel: 'جزء ٢٢',
    pdfAsset: 'assets/Colour Coded Quran Juz 22.pdf',
  ),
  Para(
    number: 23,
    name: 'Wa Mali',
    subtitle: 'Para 23',
    arabicLabel: 'جزء ٢٣',
    pdfAsset: 'assets/Colour Coded Quran Juz 23.pdf',
  ),
  Para(
    number: 24,
    name: 'Faman Azlam',
    subtitle: 'Para 24',
    arabicLabel: 'جزء ٢٤',
    pdfAsset: 'assets/Colour Coded Quran Juz 24.pdf',
  ),
  Para(
    number: 25,
    name: 'Elahe Yuruddo',
    subtitle: 'Para 25',
    arabicLabel: 'جزء ٢٥',
    pdfAsset: 'assets/Colour Coded Quran Juz 25.pdf',
  ),
  Para(
    number: 26,
    name: 'Ha\'a Meem',
    subtitle: 'Para 26',
    arabicLabel: 'جزء ٢٦',
    pdfAsset: 'assets/Colour Coded Quran Juz 26.pdf',
  ),
  Para(
    number: 27,
    name: 'Qala Fama Khatbukum',
    subtitle: 'Para 27',
    arabicLabel: 'جزء ٢٧',
    pdfAsset: 'assets/Colour Coded Quran Juz 27.pdf',
  ),
  Para(
    number: 28,
    name: 'Qadd Sami Allah',
    subtitle: 'Para 28',
    arabicLabel: 'جزء ٢٨',
    pdfAsset: 'assets/Colour Coded Quran Juz 28.pdf',
  ),
  Para(
    number: 29,
    name: 'Tabarakallazi',
    subtitle: 'Para 29',
    arabicLabel: 'جزء ٢٩',
    pdfAsset: 'assets/Colour Coded Quran Juz 29.pdf',
  ),
  Para(
    number: 30,
    name: 'Amma Yatasa\'aloon',
    subtitle: 'Para 30',
    arabicLabel: 'جزء ٣٠',
    pdfAsset: 'assets/Colour Coded Quran Juz 30.pdf',
  ),
];
