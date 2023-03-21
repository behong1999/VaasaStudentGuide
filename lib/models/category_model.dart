import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:students_guide/gen/assets.gen.dart';
import 'package:students_guide/utils/custom/c_icons.dart';
import 'package:students_guide/utils/enums.dart';

class CategoryModel {
  final String image;
  final Categories category;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.image,
    required this.category,
    required this.icon,
    required this.color,
  });
}

final categoryList = [
  CategoryModel(
    image: Assets.images.education.path,
    category: Categories.education,
    icon: Icons.school,
    color: const Color(0xFFDCCA24),
  ),
  CategoryModel(
    image: Assets.images.residence.path,
    category: Categories.residence,
    icon: Icons.home_work_outlined,
    color: const Color(0xFF329404),
  ),
  CategoryModel(
    image: Assets.images.restaurant.path,
    category: Categories.restaurant,
    icon: FontAwesomeIcons.burger,
    color: const Color(0xFFFA9A00),
  ),
  CategoryModel(
    image: Assets.images.sports.path,
    category: Categories.sports,
    icon: CustomIcons.badminton,
    color: const Color(0xFF9E0000),
  ),
  CategoryModel(
    image: Assets.images.community.path,
    category: Categories.community,
    icon: Icons.groups_sharp,
    color: const Color(0xFF2EA0F9),
  ),
  CategoryModel(
    image: Assets.images.jobs.path,
    category: Categories.jobs,
    icon: FontAwesomeIcons.suitcase,
    color: const Color(0xFF6B16C0),
  ),
];
