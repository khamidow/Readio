class PdfBook {
  final String title;
  final String pdfUrl;
  final String coverUrl;
  final List<String> audioUrls;

  PdfBook({
    required this.title,
    required this.pdfUrl,
    required this.coverUrl,
    required this.audioUrls,
  });
}