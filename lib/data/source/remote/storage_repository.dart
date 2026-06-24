import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/pdf_book.dart';

class StorageRepository {
  final supabase = Supabase.instance.client;

  Future<List<PdfBook>> getAllPdfs() async {
    final files = await supabase.storage
        .from('user-documents-pdf')
        .list(path: 'books');

    final books = await Future.wait(
      files
          .where((file) => file.name.endsWith('.pdf'))
          .map((file) async {
        final baseName = file.name.substring(0, file.name.length - 4);

        final pdfUrl = await supabase.storage
            .from('user-documents-pdf')
            .createSignedUrl('books/${file.name}', 60 * 60);

        final coverUrl = await supabase.storage
            .from('user-documents-pdf')
            .createSignedUrl('covers/$baseName.jpg', 60 * 60);

        final audioFiles = await supabase.storage
            .from('user-documents-pdf')
            .list(path: baseName);

        final audioUrls = await Future.wait(
          audioFiles
              .where((f) =>
          f.name.endsWith('.mp3') ||
              f.name.endsWith('.m4a') ||
              f.name.endsWith('.wav'))
              .map((audio) async {
            return await supabase.storage
                .from('user-documents-pdf')
                .createSignedUrl(
              '$baseName/${audio.name}',
              60 * 60,
            );
          }),
        );

        return PdfBook(
          title: baseName,
          pdfUrl: pdfUrl,
          coverUrl: coverUrl,
          audioUrls: audioUrls,
        );
      }),
    );

    return books;
  }
}