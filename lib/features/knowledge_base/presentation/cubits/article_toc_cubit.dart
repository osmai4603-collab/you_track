import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ArticleTocState extends Equatable {
  const ArticleTocState();

  @override
  List<Object?> get props => [];
}

class TocInitial extends ArticleTocState {}

class TocLoaded extends ArticleTocState {
  final List<String> headings;
  const TocLoaded(this.headings);

  @override
  List<Object?> get props => [headings];
}

class TocEmpty extends ArticleTocState {}

class ArticleTocCubit extends Cubit<ArticleTocState> {
  ArticleTocCubit() : super(TocInitial());

  final ScrollController _scrollController = ScrollController();
  List<double> _headingOffsets = [];

  ScrollController get scrollController => _scrollController;

  void extractHeadings(String markdown) {
    final headingRegex = RegExp(r'^(#{1,6})\s+(.+)$', multiLine: true);
    final matches = headingRegex.allMatches(markdown);
    final headings = matches.map((m) => m.group(0)!.trim()).toList();

    if (headings.isEmpty) {
      emit(TocEmpty());
    } else {
      emit(TocLoaded(headings));
    }

    _headingOffsets = List<double>.filled(headings.length, 0.0);
  }

  void updateOffsets(List<double> offsets) {
    _headingOffsets = offsets;
  }

  void scrollToHeading(int index) {
    if (index < _headingOffsets.length && _scrollController.hasClients) {
      _scrollController.animateTo(
        _headingOffsets[index],
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Future<void> close() {
    _scrollController.dispose();
    return super.close();
  }
}
