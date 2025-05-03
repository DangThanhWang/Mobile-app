import 'package:app/Definitons/size_config.dart';

double animatedPositionedLEftValue(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return AppSizes.blockSizeHorizontal * 5.5;
    case 1:
      return AppSizes.blockSizeHorizontal * 22.5;
    case 2:
      return AppSizes.blockSizeHorizontal * 39.5;
    case 3:
      return AppSizes.blockSizeHorizontal * 56.5;
    case 4:
      return AppSizes.blockSizeHorizontal * 73.5;
    default:
      return 0;
  }
}

// ignore: constant_identifier_names
const API_KEY = 'AIzaSyDoD2FNKWnr6xtGGJwNCCQ6tmjtHqua8JE';

// ignore: constant_identifier_names
const MONGO_URL =
    'mongodb+srv://dinhductai2004:Tai03102004@englishapp.3ryiky2.mongodb.net/EnglishApp?retryWrites=true&w=majority&appName=EnglishApp';

// ignore: constant_identifier_names
const COLLECTION_Users = 'Users';
// ignore: constant_identifier_names
const COLLECTION_Rooms = 'Rooms';
