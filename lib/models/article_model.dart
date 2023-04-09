import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_guide/services/articles/cloud_const.dart';

class ArticleModel {
  String? documentId;
  final String title;
  final String category;
  final String intro;
  final String info;
  final DateTime date;
  String? lastModifiedBy;
  final String? imageUrl;
  final String? address;
  final String? email;
  final String? tel;
  final String? website;

  ArticleModel({
    this.documentId,
    required this.title,
    required this.category,
    required this.intro,
    required this.info,
    required this.date,
    this.lastModifiedBy,
    this.imageUrl,
    this.address,
    this.email,
    this.tel,
    this.website,
  });

  //* For Stars View
  ArticleModel.fromMap(Map<String, dynamic> map)
      : documentId = map[documentIdField],
        title = map[titleField],
        category = map[categoryField],
        intro = map[introField],
        info = map[infoField],
        date = DateTime.parse(map[dateField]),
        imageUrl = map[imageUrlField],
        address = map[addressField],
        email = map[emailField],
        tel = map[telField],
        website = map[websiteField];

  //* For Stars Service
  Map<String, dynamic> toMap() {
    return {
      documentIdField: documentId,
      titleField: title,
      categoryField: category,
      introField: intro,
      infoField: info,
      dateField: date.toIso8601String(),
      imageUrlField: imageUrl,
      addressField: address,
      emailField: email,
      telField: tel,
      websiteField: website,
    };
  }

  //* For Articles View
  ArticleModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapShot)
      : documentId = snapShot.id,
        title = snapShot.data()[titleField],
        category = snapShot.data()[categoryField],
        intro = snapShot.data()[introField],
        info = snapShot.data()[infoField],
        date = DateTime.parse(snapShot.data()[dateField]),
        lastModifiedBy = snapShot.data()[lastModifiedByField],
        imageUrl = snapShot.data()[imageUrlField],
        address = snapShot.data()[addressField],
        email = snapShot.data()[emailField],
        tel = snapShot.data()[telField],
        website = snapShot.data()[websiteField];

  //* For Cloud Service
  Map<String, dynamic> toJson() {
    return {
      documentIdField: documentId,
      titleField: title,
      categoryField: category,
      introField: intro,
      infoField: info,
      dateField: date.toIso8601String(),
      lastModifiedByField: lastModifiedBy,
      imageUrlField: imageUrl,
      addressField: address,
      emailField: email,
      telField: tel,
      websiteField: website,
    };
  }
}
