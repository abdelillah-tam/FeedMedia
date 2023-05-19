import 'package:feedmedia/services/user/local_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import '../../model/user.dart';

class LocalUserService extends LocalUserProvider {
  Database? _db;

  @override
  Future<dynamic> register({
    String? email,
    String? accessToken,
    User? user,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    await db.insert(userTableName, <String, dynamic>{
      idFieldName: user!.id,
      emailFieldName: user.email,
      objectIdFieldName: user.objectId,
      userTokenFieldName: user.userToken,
      nameFieldName: user.name,
      firstNameFieldName: user.firstName,
      lastNameFieldName: user.lastName,
      isPasswordCreatedFieldName: user.isPasswordCreated,
      followersObjectIdFieldName: user.followersObjectId,
      userUidFieldName: '',
      profileImageObjectFieldName: null,
    });
  }

  @override
  Future<User?> getUser() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    final list = await db.query(userTableName);
    if (list.isNotEmpty) {
      return User(
        id: list[0][idFieldName].toString(),
        email: list[0][emailFieldName].toString(),
        name: list[0][nameFieldName].toString(),
        objectId: list[0][objectIdFieldName].toString(),
        userToken: list[0][userTokenFieldName].toString(),
        firstName: list[0][firstNameFieldName].toString(),
        lastName: list[0][lastNameFieldName].toString(),
        isPasswordCreated: list[0][isPasswordCreatedFieldName] as int,
        followersObjectId: list[0][followersObjectIdFieldName].toString(),
        userUID: list[0][userUidFieldName].toString(),
        profileImageUrl: list[0][profileImageObjectFieldName].toString(),
      );
    } else {
      return null;
    }
  }

  Database _getDatabaseOrThrown() {
    final db = _db;
    if (db == null) {
      throw Exception;
    } else {
      return db;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } catch (e) {}
  }

  @override
  Future<void> open() async {
    if (_db != null) {
      throw Exception;
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
    } on MissingPlatformDirectoryException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> createPassword(int isPasswordCreated) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    final userId = await db.update(
      userTableName,
      <String, dynamic>{
        isPasswordCreatedFieldName: isPasswordCreated,
        userUidFieldName: FirebaseAuth.instance.currentUser!.uid,
      },
    );

    return userId != 0 ? true : false;
  }

  @override
  Future<User?> login(
    User user,
  ) async {
    await _ensureDbIsOpen();
    clearTable();
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    final userId = await db.insert(userTableName, <String, dynamic>{
      idFieldName: user.id,
      emailFieldName: user.email,
      objectIdFieldName: user.objectId,
      userTokenFieldName: user.userToken,
      nameFieldName: user.name,
      firstNameFieldName: user.firstName,
      lastNameFieldName: user.lastName,
      isPasswordCreatedFieldName: user.isPasswordCreated,
      followersObjectIdFieldName: user.followersObjectId,
      userUidFieldName: user.userUID,
      profileImageObjectFieldName: user.profileImageUrl,
    });

    if (userId != 0) {
      final gotUser = await db.query(
        userTableName,
        where: '$objectIdFieldName = ?',
        whereArgs: [user.objectId],
      );

      final userFromDb = User(
        id: gotUser[0][idFieldName].toString(),
        email: gotUser[0][emailFieldName].toString(),
        name: gotUser[0][nameFieldName].toString(),
        objectId: gotUser[0][objectIdFieldName].toString(),
        userToken: gotUser[0][userTokenFieldName].toString(),
        firstName: gotUser[0][firstNameFieldName].toString(),
        lastName: gotUser[0][lastNameFieldName].toString(),
        isPasswordCreated: gotUser[0][isPasswordCreatedFieldName] as int,
        followersObjectId: gotUser[0][followersObjectIdFieldName].toString(),
        userUID: gotUser[0][userUidFieldName].toString(),
        profileImageUrl: gotUser[0][profileImageObjectFieldName].toString(),
      );
      return userFromDb;
    }
  }

  @override
  Future<bool> updateFirstAndLastName({
    required String? firstName,
    required String? lastName,
    required String objectId,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    final userId = await db.update(
      userTableName,
      <String, dynamic>{
        firstNameFieldName: firstName,
        lastNameFieldName: lastName,
      },
      where: '$objectIdFieldName = ?',
      whereArgs: [objectId],
    );

    return userId != 0 ? true : false;
  }

  @override
  void clearTable() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    await db.delete(userTableName);
  }

  // This function just for updating db if needed
  /*_alterTable() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    await db.execute('ALTER TABLE $userTableName ADD COLUMN $profileImageObjectFieldName TEXT');
  }*/

  @override
  Future<bool> updateProfilePictureUrl({required String url, required String userObjectId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrown();

    final userId = await db.update(
        userTableName,
        <String, String>{
          profileImageObjectFieldName: url,
        },
        where: '$objectIdFieldName = ?',
        whereArgs: [userObjectId]);

    return userId != 0 ? true : false;
  }
}

const dbName = 'feedmedia.db';
const createUserTable = '''CREATE TABLE IF NOT EXISTS $userTableName (
$idFieldName TEXT,
$emailFieldName TEXT NOT NULL,
$objectIdFieldName TEXT NOT NULL,
$nameFieldName TEXT,
$userTokenFieldName TEXT NOT NULL,
$firstNameFieldName TEXT NOT NULL,
$lastNameFieldName TEXT NOT NULL,
$userUidFieldName TEXT NOT NULL,
$isPasswordCreatedFieldName INTEGER NOT NULL,
$followersObjectIdFieldName TEXT NOT NULL,
$profileImageObjectFieldName TEXT,
PRIMARY KEY ("id")
);
''';
const userTableName = 'user';
const idFieldName = 'id';
const emailFieldName = 'email';
const objectIdFieldName = 'objectId';
const nameFieldName = 'name';
const userUidFieldName = 'userUID';
const userTokenFieldName = 'user_token';
const firstNameFieldName = 'first_name';
const lastNameFieldName = 'last_name';
const isPasswordCreatedFieldName = 'isPasswordCreated';
const followersObjectIdFieldName = 'followersObjectId';
const profileImageObjectFieldName = 'profileImageUrl';
