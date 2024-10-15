abstract class AbstractApi<T> {
  Future<List<T>> fetchAll();
  Future<T> fetchById(String id);
  Future<T> create(T item);
  Future<T> update(T item);
  Future<void> delete(String id);
}
