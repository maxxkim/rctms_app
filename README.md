# RCTMS Mobile (Realtime Collaborative Task Management System)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2)](https://dart.dev/)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.x-0098FB)](https://riverpod.dev/)
[![GraphQL](https://img.shields.io/badge/GraphQL-Latest-E10098)](https://graphql.org/)

Мобильное приложение для системы управления задачами в реальном времени с коллаборативными функциями. Построено с использованием Flutter и современной архитектуры чистого кода.

## 🔗 Связанные проекты

- [RCTMS Backend](https://github.com/your-username/rctms-backend) - Бэкенд на Elixir/Phoenix для данного приложения

## 📖 Обзор проекта

RCTMS Mobile — это клиентское приложение для системы управления задачами и проектами, демонстрирующее современный подход к разработке мобильных приложений с использованием Flutter, Riverpod и GraphQL. Приложение предоставляет интуитивно понятный интерфейс для управления проектами, задачами и командной работы в реальном времени.

Ключевые особенности архитектуры:
- **Clean Architecture** - четкое разделение слоев приложения для улучшения тестируемости и поддерживаемости
- **Riverpod для управления состоянием** - современное и гибкое управление состоянием с помощью Riverpod
- **GraphQL интеграция** - эффективное взаимодействие с API с использованием GraphQL
- **Реактивное обновление** - обновления в реальном времени через WebSockets
- **Офлайн-режим** - локальное хранение данных для работы без подключения к сети

## 🚀 Возможности

- **Современный UI** - Чистый, интуитивно понятный интерфейс пользователя с поддержкой светлой и темной темы
- **Аутентификация** - Безопасный вход и регистрация пользователей с JWT
- **Управление проектами** - Создание, просмотр и редактирование проектов
- **Управление задачами** - Полный функционал для работы с задачами (создание, редактирование, назначение, изменение статуса)
- **Приоритизация задач** - Отмечайте важность задач с помощью приоритетов (низкий, средний, высокий)
- **Комментарии** - Обсуждение задач с помощью системы комментариев
- **Реальное время** - Обновления в реальном времени благодаря WebSocket-соединениям
- **Офлайн-режим** - Работа в офлайн-режиме с последующей синхронизацией
- **Защищенное хранение** - Безопасное хранение токенов и чувствительных данных

## 📋 Требования

- Flutter 3.x
- Dart 3.x
- Android Studio или VS Code с плагинами Flutter
- Android SDK для Android-разработки
- Xcode (для iOS-разработки на macOS)
- Подключение к RCTMS Backend

## 🛠️ Установка и настройка

### Подготовка среды разработки

1. **Установите Flutter SDK**:
   
   Следуйте официальной инструкции по установке Flutter: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

2. **Настройте редактор кода**:
   
   Установите Android Studio или VS Code с плагинами Flutter и Dart

3. **Проверьте настройку Flutter**:
   ```bash
   flutter doctor
   ```
   Исправьте все обнаруженные проблемы

### Клонирование и настройка проекта

1. **Клонируйте репозиторий**:
   ```bash
   git clone https://github.com/your-username/rctms-mobile.git
   cd rctms-mobile
   ```

2. **Установите зависимости**:
   ```bash
   flutter pub get
   ```

3. **Сгенерируйте необходимые файлы**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Настройте подключение к серверу**:
   
   Отредактируйте файл `lib/app/core/constants/api_constants.dart` для настройки соединения с вашим бэкендом:
   ```dart
   static const String baseUrl = 'http://your-backend-url';
   static const String graphqlEndpoint = '$baseUrl/api/graphql';
   static const String socketEndpoint = '$baseUrl/socket';
   ```

### Запуск приложения

1. **Запустите в режиме отладки**:
   ```bash
   flutter run
   ```

2. **Запустите для конкретной платформы**:
   ```bash
   flutter run -d android # для Android
   flutter run -d ios     # для iOS
   ```

## 📂 Структура проекта

Проект следует принципам Clean Architecture с четким разделением на слои:

```
lib/
├── app/
│   ├── core/                     # Основные утилиты, константы, базовые классы
│   │   ├── constants/            # Константы приложения (API URLs, строки и т.д.)
│   │   │   └── api_constants.dart # Константы для API
│   │   ├── errors/               # Обработка ошибок
│   │   │   ├── exceptions.dart    # Определения исключений
│   │   │   └── failure.dart       # Классы ошибок для бизнес-логики
│   │   ├── network/              # Сетевые клиенты и утилиты
│   │   │   ├── graphql_client.dart # GraphQL клиент
│   │   │   └── network_info.dart   # Проверка подключения
│   │   └── storage/              # Локальное хранилище
│   │       └── secure_storage.dart # Безопасное хранилище для токенов
│   ├── data/                     # Слой данных
│   │   ├── models/               # Модели данных
│   │   │   ├── comment_model.dart  # Модель комментария
│   │   │   ├── project_model.dart  # Модель проекта
│   │   │   ├── task_model.dart     # Модель задачи
│   │   │   └── user_model.dart     # Модель пользователя
│   │   └── repositories/         # Репозитории для работы с данными
│   │       └── auth_repository.dart # Репозиторий аутентификации
│   ├── domain/                   # Бизнес-логика
│   │   └── entities/             # Бизнес-сущности
│   │       ├── comment.dart        # Сущность комментария
│   │       ├── project.dart        # Сущность проекта
│   │       ├── task.dart           # Сущность задачи
│   │       └── user.dart           # Сущность пользователя
│   ├── presentation/             # UI слой
│   │   ├── auth/                 # Экраны и виджеты для аутентификации
│   │   │   ├── screens/            # Экраны аутентификации
│   │   │   │   ├── login_screen.dart  # Экран входа
│   │   │   │   └── register_screen.dart # Экран регистрации
│   │   │   └── widgets/            # Виджеты аутентификации
│   │   │       ├── login_form.dart    # Форма входа
│   │   │       └── register_form.dart # Форма регистрации
│   │   ├── home/                 # Главный экран и навигация
│   │   │   └── screens/            # Основные экраны
│   │   │       └── home_screen.dart  # Главный экран
│   │   ├── projects/             # Экраны и виджеты для проектов
│   │   └── tasks/                # Экраны и виджеты для задач
│   ├── providers/                # Riverpod провайдеры
│   │   └── auth_providers.dart     # Провайдеры для аутентификации
│   ├── app.dart                  # Основной виджет приложения
│   ├── router.dart               # Маршрутизация приложения
│   └── theme.dart                # Темы приложения
└── main.dart                     # Точка входа приложения
```

## 📱 Функциональность и особенности

### Аутентификация и авторизация

RCTMS Mobile предоставляет полную систему аутентификации с:
- Регистрацией новых пользователей
- Входом существующих пользователей
- Безопасным хранением JWT-токенов
- Автоматическим обновлением токенов
- Проверкой статуса аутентификации при запуске

Пример использования аутентификации:
```dart
// Вход пользователя
await ref.read(authProvider.notifier).login(email, password);

// Проверка статуса аутентификации
final authState = ref.watch(authProvider);
if (authState.isAuthenticated) {
  // Пользователь аутентифицирован
} else {
  // Пользователь не аутентифицирован
}
```

### GraphQL интеграция

Приложение использует GraphQL для эффективного взаимодействия с API:
- Оптимизированная загрузка данных с выборочными полями
- Удобный кэширование и повторение запросов
- Автоматическая типизация ответов API

Пример GraphQL запроса:
```dart
const String query = r'''
query Me {
  me {
    id
    email
    username
    insertedAt
    updatedAt
  }
}
''';

final QueryOptions options = QueryOptions(
  document: gql(query),
);

final QueryResult result = await client.query(options);
```

### Управление состоянием с Riverpod

RCTMS использует Riverpod для гибкого и эффективного управления состоянием:
- StateNotifier для состояний с логикой
- Provider для доступа к сервисам и зависимостям
- Асинхронные провайдеры для загрузки данных

Пример использования Riverpod:
```dart
// Определение провайдера
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  
  return AuthNotifier(
    authRepository: authRepository,
    secureStorage: secureStorage,
  );
});

// Использование провайдера в виджете
final authState = ref.watch(authProvider);
```

### Локальное хранение и безопасность

Приложение обеспечивает безопасное хранение данных:
- Использование flutter_secure_storage для токенов и чувствительных данных
- Использование Hive для локального кэширования данных
- Обеспечение изоляции данных и шифрования

```dart
// Пример сохранения токена
await secureStorage.storeAuthToken(token);

// Пример получения токена
final token = await secureStorage.getAuthToken();
```

## 🎨 Скриншоты
![Simulator Screenshot - iPhone 16 Plus - 2025-05-19 at 17 26 27](https://github.com/user-attachments/assets/52d5d3b5-0f25-42fa-90eb-9edde7624ed4)
![Simulator Screenshot - iPhone 16 Plus - 2025-05-19 at 17 26 33](https://github.com/user-attachments/assets/5d5ad3bd-b4c8-48f5-a41e-4dc21ede2f66)
![Simulator Screenshot - iPhone 16 Plus - 2025-05-19 at 17 26 53](https://github.com/user-attachments/assets/700c5930-c004-47d6-b403-1f2aa9993d48)
![Simulator Screenshot - iPhone 16 Plus - 2025-05-19 at 17 26 57](https://github.com/user-attachments/assets/a5027890-2a36-445b-9b41-721dfa2db14d)
![Simulator Screenshot - iPhone 16 Plus - 2025-05-19 at 17 27 01](https://github.com/user-attachments/assets/42302ee8-a5c3-4a9e-951f-a57a2ae7124b)
![Simulator Screenshot - iPhone 16 Plus - 2025-05-19 at 17 27 24](https://github.com/user-attachments/assets/7a836360-0572-42de-b97f-6ab7c9670e67)

## 🧰 Используемые технологии

- **Flutter** - UI фреймворк
- **Riverpod** - Управление состоянием
- **GraphQL Flutter** - Клиент GraphQL
- **Phoenix Socket** - WebSocket клиент для Phoenix Channels
- **Hive** - Локальное хранилище
- **Flutter Secure Storage** - Безопасное хранилище для токенов
- **Connectivity Plus** - Проверка сетевого подключения
- **JSON Serializable** - Кодирование/декодирование JSON

## 💻 Примеры кода

### Настройка GraphQL клиента

```dart
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rctms/app/core/constants/api_constants.dart';
import 'package:rctms/app/core/storage/secure_storage.dart';

class GraphQLClientProvider {
  final SecureStorage secureStorage;
  
  GraphQLClientProvider(this.secureStorage);
  
  Future<GraphQLClient> getClient() async {
    final token = await secureStorage.getAuthToken();
    
    final httpLink = HttpLink(ApiConstants.graphqlEndpoint);
    
    final authLink = AuthLink(
      getToken: () => token != null ? 'Bearer $token' : null,
    );
    
    final Link link = authLink.concat(httpLink);
    
    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
}
```

### Авторизация пользователя

```dart
Future<void> login(String email, String password) async {
  state = state.copyWith(authStatus: const AsyncValue.loading());
  
  try {
    final result = await _authRepository.login(email, password);
    final user = result['user'] as UserModel;
    final token = result['token'] as String;
    
    await _secureStorage.storeAuthToken(token);
    await _secureStorage.storeUserId(user.id);
    
    state = state.copyWith(
      user: user,
      authStatus: const AsyncValue.data(null),
      isAuthenticated: true,
    );
  } catch (e) {
    state = state.copyWith(
      authStatus: AsyncValue.error(e, StackTrace.current),
      isAuthenticated: false,
    );
  }
}
```

## 🧪 Тестирование

RCTMS Mobile включает комплексную стратегию тестирования на всех уровнях:

### Unit Tests

```bash
# Запуск всех юнит-тестов
flutter test
```

### Widget Tests

```bash
# Запуск конкретного виджет-теста
flutter test test/app/presentation/auth/widgets/login_form_test.dart
```

### Integration Tests

```bash
# Запуск интеграционных тестов
flutter test integration_test/app_test.dart
```

### Тестирование с покрытием

```bash
# Запуск тестов с отчётом о покрытии
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚢 Сборка и выпуск приложения

### Android

```bash
# Сборка APK-файла
flutter build apk --release

# Сборка App Bundle для Google Play
flutter build appbundle --release
```

### iOS

```bash
# Сборка IPA-файла (только на macOS)
flutter build ios --release
```

### Подготовка проекта к релизу

1. **Обновите номер версии** в `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1  # <версия>+<номер сборки>
   ```

2. **Подготовьте ресурсы**:
   - Иконки приложения
   - Splash экран
   - Скриншоты для магазинов приложений

3. **Настройте конфигурационные файлы платформ**:
   - `android/app/build.gradle` для Android
   - `ios/Runner.xcodeproj/project.pbxproj` для iOS

## 📚 Рекомендации по разработке

### Стиль кода

RCTMS Mobile следует официальному руководству по стилю Dart:
- Используйте `dart format` для форматирования кода
- Следуйте [Effective Dart: Style](https://dart.dev/guides/language/effective-dart/style)
- Используйте lint правила из `analysis_options.yaml`

### Структура кода

- Следуйте принципам Clean Architecture
- Используйте реактивное программирование с Riverpod
- Отделяйте бизнес-логику от представления
- Используйте Dependency Injection для улучшения тестируемости

### Git Workflow

1. Создайте ветку для функции или исправления (`feature/new-feature` или `fix/bug-description`)
2. Разрабатывайте функциональность с частыми коммитами
3. Оформите Pull Request с подробным описанием изменений
4. Дождитесь code review и CI проверок
5. Выполните merge в основную ветку

## 🧵 Многопоточность и производительность

RCTMS Mobile оптимизирован для плавной работы:

- **Изоляты** для тяжелых вычислений
- **Асинхронная загрузка** данных для отзывчивости UI
- **Эффективное кэширование** для быстрого доступа к данным
- **Ленивая загрузка** ресурсов по мере необходимости

## 🔍 Отладка и профилирование

### Flutter DevTools

Используйте Flutter DevTools для:
- Отладки виджетов и макетов
- Анализа производительности
- Отслеживания сетевых запросов
- Инспектирования состояния приложения

```bash
# Запуск DevTools
flutter run --device-id=<device-id> --debug
```

### Логирование

RCTMS использует структурированное логирование:
```dart
// Импорт
import 'package:logging/logging.dart';

// Создание логгера
final _logger = Logger('AuthRepository');

// Использование
_logger.info('Authenticating user: $email');
_logger.warning('Failed login attempt: $error');
```

## 🛣️ Дорожная карта

- [x] Аутентификация пользователей
- [x] Базовый функционал проектов и задач
- [x] GraphQL интеграция
- [ ] Глубокая интеграция для обновлений в реальном времени
- [ ] Полный офлайн-режим с синхронизацией
- [ ] Вложения и файлы для задач
- [ ] Совместное редактирование задач
- [ ] Продвинутая фильтрация и поиск
- [ ] Оптимизация производительности и UX
- [ ] Локализация на несколько языков
- [ ] Push-уведомления
- [ ] Интеграция с календарем и напоминаниями

## ❓ FAQ

### Как настроить соединение с бэкендом?

Отредактируйте `lib/app/core/constants/api_constants.dart` для указания URL вашего бэкенда:
```dart
static const String baseUrl = 'http://your-backend-url';
```

### Как добавить новую функциональность?

1. Определите требуемую функциональность в domain слое
2. Реализуйте хранение данных и API взаимодействие в data слое
3. Создайте необходимые провайдеры в providers
4. Разработайте пользовательский интерфейс в presentation слое

### Как добавить новый экран?

1. Создайте новый экран в соответствующей директории в `presentation/`
2. Добавьте маршрут к экрану в `router.dart`
3. Обновите навигацию для доступа к новому экрану

### Как мне отлаживать GraphQL запросы?

Используйте GraphiQL интерфейс бэкенда для проверки запросов: [http://localhost:4000/api/graphiql](http://localhost:4000/api/graphiql)

## 🧩 Вклад в проект

Вклады приветствуются! Пожалуйста, ознакомьтесь с нашим [руководством по вкладу](CONTRIBUTING.md) для получения информации о том, как участвовать в разработке.

## 📄 Лицензия

Этот проект лицензирован под [MIT License](LICENSE).

## 👥 Контакты и поддержка

- Создайте Issue в репозитории для сообщения о проблеме или запроса функций
- Присоединяйтесь к дискуссии в нашем канале Slack или Discord (TODO: добавить ссылки)
- Свяжитесь с командой разработчиков по email: [your-email@example.com](mailto:your-email@example.com)
