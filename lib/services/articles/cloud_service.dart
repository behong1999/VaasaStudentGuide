import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/articles/cloud_const.dart';
import 'package:students_guide/services/articles/cloud_firebase_exception.dart';

class CloudService {
  //* Singleton
  static final CloudService _shared = CloudService._sharedInstance();

  //* It promises to return _an_ object of this type
  //* but it doesn't promise to make a new one.
  factory CloudService() => _shared;

  //* It'll be called exactly once, by the static property assignment above
  CloudService._sharedInstance();

  final _collection = FirebaseFirestore.instance.collection(articlesCollection);

  addNewArticle(ArticleModel cloudArticle) async {
    try {
      final document = _collection.doc();
      cloudArticle.documentId = document.id;
      await document.set(cloudArticle.toJson());
    } catch (e) {
      throw CannotAddNewArticle();
    }
  }

  updateArticle(ArticleModel cloudArticle) async {
    try {
      final document = _collection.doc(cloudArticle.documentId);
      await document.update(cloudArticle.toJson());
    } catch (e) {
      throw CannotUpdateArticle();
    }
  }

  Stream<Iterable<ArticleModel>> getAllArticles() {
    try {
      return _collection.snapshots().map(
            (event) => event.docs.map(
              (doc) => ArticleModel.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CannotGetAllArticles();
    }
  }

  Stream<Iterable<ArticleModel>> getArticlesByCategory(
      {required String category}) {
    try {
      return _collection
          .where(categoryField, isEqualTo: category)
          .snapshots()
          .map(
            (event) => event.docs.map(
              (doc) => ArticleModel.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CannotGetAllArticles();
    }
  }

  deleteArticle(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      throw CannotDeleteArticle();
    }
  }
}
