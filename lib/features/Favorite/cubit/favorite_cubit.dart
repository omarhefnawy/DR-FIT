import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FavoriteCubit() : super(FavoriteInitial()) {
    _loadFavorites(); // (اختياري) إذا أردت تحميل المفضلات مباشرة
  }

  Future<void> toggleFavorite(Exercise exercise) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      final docRef = _firestore
          .collection('favorites')
          .doc(userId)
          .collection('exercises')
          .doc(exercise.id);

      final docExists = await docRef.get().then((doc) => doc.exists);

      if (docExists) {
        await docRef.delete(); // إزالة من المفضلة
      } else {
        await docRef.set(exercise.toMap()); // ✅ يتم حفظ كل المعلومات الآن
      }

      emit(FavoriteUpdated());
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Stream<List<Exercise>> getFavoritesStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.empty();

    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('exercises')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Exercise.fromMap(doc.data())).toList());
  }

  Future<void> _loadFavorites() async {
    // ملاحظة: يُفضّل استخدام الـ Stream بدلاً من هذا لتحميل مباشر وتلقائي
  }
}
