import 'package:test_venzel/models/category.dart';
import 'package:test_venzel/repositories/repository.dart';

class CategoryService {
  Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  // Create data
  saveCategory(Category category) async {
    return await _repository.insertData(
      'categories',
      category.categoryMap(),
    );
  }

  // Read data
  readCategories() async {
    return await _repository.readData('categories');
  }

  // Read data by id
  readCategoryById(categoryId) async {
    return await _repository.readDataById(
      'categories',
      categoryId,
    );
  }

  // Update data
  updateCategory(Category category) async {
    return await _repository.updateData(
      'categories',
      category.categoryMap(),
    );
  }

  // Delete data
  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }
}
