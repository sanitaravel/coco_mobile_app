import 'package:cloud_firestore/cloud_firestore.dart';
import '../blocs/task_model.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'tasks';

  Stream<List<Task>> tasksStreamForUser(String uid) {
    return _db
        .collection(collection)
        .where('ownerId', isEqualTo: uid)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((d) => TaskFirestore.fromMap(d.id, d.data()))
          .toList());
  }

  Future<String> createTask(String uid, Task task) async {
    final docRef = await _db.collection(collection).add({
      ...task.toMap(),
      'ownerId': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> updateTask(String uid, Task task) async {
    final data = {
      ...task.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _db.collection(collection).doc(task.id).update(data);
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _db.collection(collection).doc(taskId).delete();
  }
}
