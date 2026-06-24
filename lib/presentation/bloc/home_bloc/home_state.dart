part of 'home_bloc.dart';

class HomeState {
  final List<PdfBook> books;
  final bool isLoading;

  HomeState(this.books, this.isLoading);

  HomeState copyWith({List<PdfBook>? books, bool? isLoading}) =>
      HomeState(books ?? this.books, isLoading ?? this.isLoading);
}
