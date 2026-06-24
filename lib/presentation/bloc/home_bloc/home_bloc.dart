import 'package:audio_pdf_book_flutter/data/source/remote/storage_repository.dart';
import 'package:audio_pdf_book_flutter/models/pdf_book.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StorageRepository _storageRepository = StorageRepository();

  HomeBloc() : super(HomeState([], false)) {
    on<LoadBooksEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final books = await _storageRepository.getAllPdfs();
        print("BOOKS LOADED: ${books.length}");
        emit(state.copyWith(books: books, isLoading: false));
      } catch (e) {
        print("BLOC ERROR: $e");
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}
