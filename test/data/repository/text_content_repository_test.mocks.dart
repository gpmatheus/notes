// Mocks generated by Mockito 5.4.4 from annotations
// in notes/test/data/repository/text_content_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:notes/data/services/local/interfaces/local_text_content_service.dart'
    as _i2;
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart'
    as _i5;
import 'package:notes/data/services/local/interfaces/model/content/types/text/textcontent_dto.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [LocalTextContentService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalTextContentService extends _i1.Mock
    implements _i2.LocalTextContentService {
  MockLocalTextContentService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.TextcontentDto?> createTextContent(
          _i4.TextcontentDto? content) =>
      (super.noSuchMethod(
        Invocation.method(
          #createTextContent,
          [content],
        ),
        returnValue: _i3.Future<_i4.TextcontentDto?>.value(),
      ) as _i3.Future<_i4.TextcontentDto?>);

  @override
  _i3.Future<_i4.TextcontentDto?> updateTextContent(
    String? contentId,
    _i4.TextcontentDto? content,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTextContent,
          [
            contentId,
            content,
          ],
        ),
        returnValue: _i3.Future<_i4.TextcontentDto?>.value(),
      ) as _i3.Future<_i4.TextcontentDto?>);

  @override
  _i3.Future<_i5.ContentDto?> getContnetById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getContnetById,
          [id],
        ),
        returnValue: _i3.Future<_i5.ContentDto?>.value(),
      ) as _i3.Future<_i5.ContentDto?>);

  @override
  _i3.Future<List<_i5.ContentDto>> getContents(String? noteId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getContents,
          [noteId],
        ),
        returnValue: _i3.Future<List<_i5.ContentDto>>.value(<_i5.ContentDto>[]),
      ) as _i3.Future<List<_i5.ContentDto>>);

  @override
  _i3.Future<bool> deleteTypedContent(String? contentId) => (super.noSuchMethod(
        Invocation.method(
          #deleteTypedContent,
          [contentId],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
