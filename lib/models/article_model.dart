import 'package:students_guide/utils/enums.dart';

class ArticleModel {
  final String title;
  final Categories category;
  final String intro;
  final List<String> info;
  final DateTime date;
  final String lastModifiedBy;
  final bool isStarred;
  String? imageUrl;
  String? address;
  String? email;
  String? website;

  ArticleModel({
    required this.title,
    required this.category,
    required this.intro,
    required this.info,
    required this.date,
    required this.lastModifiedBy,
    required this.isStarred,
    this.imageUrl,
    this.address,
    this.email,
    this.website,
  });
}
