import 'package:bloc/bloc.dart';
import 'package:dr_fit/core/network/api/translotor.dart';
part 'translate_state.dart';

class TranslateCubit extends Cubit<TranslateState> {
  TranslateCubit() : super(TranslateInitial());
  String translate = '';
  Future<void> getTranslated({required List<String> messages}) async {
    emit(TranslateLoading());
    try {
      List<String> response = await Future.wait(
          messages.map((element) => Translator.translate(message: element)));

      if (response.isEmpty) {
        throw Exception("API translator returned an empty response");
      }
      translate = '';
      translate = convertList(response);

      print('The translated data is $translate');
      emit(TranslateLoaded(translate: translate));
    } catch (e, stackTrace) {
      print("Error fetching translations: ${e.toString()}\n$stackTrace");
      emit(TranslateError(
        error: e.toString(),
      ));
    }
  }

  String convertList(List string) {
    int i = 1;
    String s = '';
    for (var e in string) {
      s += ('$i - ');
      s = s + e;
      s += '\n';
      i++;
    }
    return s;
  }
}
