
import 'package:project/ScopedModel/appModel.dart';
import 'package:scoped_model/scoped_model.dart';

class Mainmodel extends Model with AppModel, UserModel, DocumentModel, SummaryModel {}
