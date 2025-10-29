import 'package:equatable/equatable.dart';

/// News category entity
class NewsCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final String color;
  final bool isActive;

  const NewsCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.color,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, description, iconPath, color, isActive];

  NewsCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    String? color,
    bool? isActive,
  }) {
    return NewsCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }
}
