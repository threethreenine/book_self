// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      workId: fields[0] as String,
      title: fields[1] as String,
      authors: (fields[2] as List).cast<Author>(),
      firstPublishedYear: fields[4] as int,
      editionCount: fields[5] as int,
      subjects: (fields[6] as List).cast<String>(),
      hasFullText: fields[8] as bool,
      publicScanAvailable: fields[9] as bool,
      coverUrl: fields[3] as String?,
      languages: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.workId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authors)
      ..writeByte(3)
      ..write(obj.coverUrl)
      ..writeByte(4)
      ..write(obj.firstPublishedYear)
      ..writeByte(5)
      ..write(obj.editionCount)
      ..writeByte(6)
      ..write(obj.subjects)
      ..writeByte(7)
      ..write(obj.languages)
      ..writeByte(8)
      ..write(obj.hasFullText)
      ..writeByte(9)
      ..write(obj.publicScanAvailable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
