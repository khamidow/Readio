import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class ReaderScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const ReaderScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  String? localPath;

  int currentPage = 0;
  int totalPages = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final dir = await getTemporaryDirectory();

      final filePath = "${dir.path}/book.pdf";

      await Dio().download(
        widget.pdfUrl,
        filePath,
      );

      setState(() {
        localPath = filePath;
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: loading
          ? const Center(
        child: CupertinoActivityIndicator(color: Colors.redAccent,),
      )
          : Stack(
        children: [
          PDFView(
            filePath: localPath!,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,

            onRender: (pages) {
              setState(() {
                totalPages = pages ?? 0;
              });
            },

            onPageChanged: (page, total) {
              setState(() {
                currentPage = page ?? 0;
              });
            },
          ),

          Positioned(
            bottom: 20,
            left: 48,
            right: 48,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Page ${currentPage + 1} / $totalPages",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}