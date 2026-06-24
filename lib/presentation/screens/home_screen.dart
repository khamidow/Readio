import 'package:audio_pdf_book_flutter/presentation/screens/audio_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc/home_bloc.dart';
import '../items/pdf_cover.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // BlocProvider moved here — created once, not on every build().
  late final HomeBloc _homeBloc;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc()..add(LoadBooksEvent());

    // Use a listener instead of setState for every keystroke — only
    // rebuilds when the trimmed query actually changes.
    _searchController.addListener(() {
      final next = _searchController.text.trim().toLowerCase();
      if (next != _query) {
        setState(() => _query = next);
      }
    });
  }

  @override
  void dispose() {
    _homeBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (prev, next) =>
        prev.isLoading != next.isLoading || prev.books != next.books,
        builder: (context, state) {
          final filteredBooks = _query.isEmpty
              ? state.books
              : state.books
              .where((b) => b.title.toLowerCase().contains(_query))
              .toList();

          return Scaffold(
            body: Container(
              color: Colors.white70,
              padding: const EdgeInsets.only(right: 26, left: 26, top: 42),
              child: Column(
                children: [
                  Container(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2),
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? GestureDetector(
                          onTap: () => _searchController.clear(),
                          child: const Icon(Icons.clear, size: 24),
                        )
                            : null,
                        hintText: 'Search books...',
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: state.isLoading
                        ? const CupertinoActivityIndicator(
                        color: Colors.redAccent)
                        : filteredBooks.isEmpty
                        ? const Center(
                      child: Text(
                        'No books found',
                        style: TextStyle(
                            color: Colors.black45, fontSize: 16),
                      ),
                    )
                        : GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.69,
                      ),
                      itemCount: filteredBooks.length,
                      // addRepaintBoundaries is true by default in
                      // GridView — each cell repaints independently.
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AudioScreen(bookData: book),
                            ),
                          ),
                          child: BookCover(imageUrl: book.coverUrl),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
