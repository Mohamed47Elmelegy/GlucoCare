---
name: app-architecture
description: "AI.MD format documentation for the Flutter App Architecture."
risk: safe
---

# App Architecture | lang:en | for-AI-parsing | optimize=results-over-format

<user>
tech-stack: Flutter 3, Dart 3
state-management: flutter_bloc
routing: go_router
dependency-injection: get_it
architecture-pattern: Clean Architecture (Feature-driven)
</user>

<gates label="Hard Gates | Priority: gates>rules>rhythm | Missing = STOP">

GATE-1 feature-structure:
  trigger: modifying or creating a feature
  action: must use lib/features/<feature_name>/(data|domain|presentation)
  exception: core utilities and shared components go to lib/core

GATE-2 state-management:
  trigger: managing state or business logic
  action: must use BLoC/Cubit pattern (flutter_bloc)
  banned: set_state for complex state

GATE-3 routing:
  trigger: app navigation
  action: must use go_router defined in lib/core/routes

GATE-4 dependency-injection:
  trigger: instantiating services, repositories, or use cases
  action: must use get_it via lib/injection_container.dart

</gates>

<rules>

CLEAN-ARCHITECTURE:

  domain:
    contains: entities, repositories (interfaces), usecases (business logic)

  data:
    contains: models, repositories (implementations), datasources (remote/local)

  presentation:
    contains: blocs/cubits, pages, widgets

ARCHITECTURE-ENFORCEMENT:

  ui-layer:
    rule: UI must NEVER access Firebase, APIs, or DataSources directly

  bloc-layer:
    rule: Bloc/Cubit must ONLY call UseCases
    banned: direct repository or datasource calls

  business-logic:
    rule: Business logic must exist ONLY inside UseCases

  repository-layer:
    rule: repositories must ONLY delegate to datasources
    banned: business logic in repositories

  datasource-layer:
    rule: Firebase or API code must exist ONLY in remote data sources

  async-pattern:
    rule: all async operations must return Either<Failure, Result>

PAGE-ARCHITECTURE:

  rule: all pages must follow the Page → Listener → View pattern

  page-layer:
    file: *_page.dart
    responsibility:
      - Scaffold
      - AppBar
      - page layout structure
    banned:
      - BlocBuilder
      - BlocConsumer
      - business logic

  listener-layer:
    file: *_listener.dart
    responsibility:
      - BlocListener
      - BlocConsumer
      - navigation
      - snackbars
      - dialogs
      - state reactions

  view-layer:
    file: *_view.dart
    responsibility:
      - pure UI rendering
    banned:
      - navigation logic
      - business logic
      - datasource access

  ui-rebuilds:
    rule: UI rebuilds must use BlocBuilder only in small widgets
    location: lib/features/<feature>/presentation/widgets

  widget-extraction:
    rule: complex UI sections must be extracted into widgets
    location: lib/features/<feature>/presentation/widgets

  example-structure:

    features/auth/presentation/pages/login/

      login_page.dart
      login_listener.dart
      login_view.dart

MONOLITHIC-WIDGET-PREVENTION:

  rule: UI files exceeding 200 lines must be split into smaller widgets

  banned:
    - large build methods
    - private UI helper methods (_buildHeader, _buildList, etc)

  required-location:
    lib/features/<feature>/presentation/widgets

DATA-PERSISTENCE:

  local:
    hive: structured local database for application data
    shared_preferences: simple key-value storage for settings and flags

  remote:
    api: REST API integration using dio/http
    firebase: backend services such as authentication

  persistence-rules:
    rule: SharedPreferences must be accessed ONLY through LocalDataSources
    rule: Hive must be accessed ONLY through LocalDataSources
    rule: UI must NEVER access local storage directly
    rule: Bloc/Cubit must NOT access persistence layers
    rule: Repositories coordinate between local and remote datasources

ERROR-HANDLING:

  rule: all async operations must return Either<Failure, Result>
  rule: use fpdart's Either for error handling
  rule: use custom Failure classes for domain errors
  rule: use try-catch only in data layer
  rule: map remote errors to domain failures in repository layer
  rule: handle UI-specific errors in presentation layer

CODE-STANDARDS:

  clean-code:
    rule: all generated code must follow Clean Code principles
    rule: keep functions small and focused on a single responsibility
    rule: avoid deep nesting
    rule: prefer composition instead of large monolithic widgets
    rule: write readable and maintainable code

  constants-policy:
    rule: never hardcode strings inside UI, blocs, or usecases
    rule: all strings must be stored in constants files
    location: lib/core/constants

    examples:
      - app_strings.dart
      - api_constants.dart
      - route_constants.dart
      - ui_constants.dart

  string-localization:
    rule: all user-visible text must be defined in constants
    example: AppStrings.login instead of "Login"

  widget-structure:
    rule: large UI pages must be split into smaller widgets
    location: lib/features/<feature>/presentation/widgets

  naming-convention:

    classes: PascalCase
    variables: camelCase
    files: snake_case

    widgets: *_widget.dart
    blocs: *_bloc.dart
    cubits: *_cubit.dart
    usecases: *_usecase.dart

  folder-discipline:

    rule: layers must never depend on higher layers

    domain:
      rule: must not import Flutter packages

    data:
      rule: must not import presentation layer

    presentation:
      rule: must not import datasources

  bloc-discipline:

    rule: blocs must remain thin
    rule: blocs should only trigger usecases
    rule: blocs must not contain business logic

  ui-discipline:

    rule: pages should only manage Scaffold and layout structure
    rule: pages must delegate state listening to Listener layer
    rule: pages must delegate UI rendering to View layer
    rule: repeated UI must be extracted into reusable widgets

  theme-and-styling:

    rule: use ContextExtensions (e.g., context.theme, context.colorScheme, context.isDark) instead of Theme.of(context) boilerplate
    rule: consistently use PremiumAppBar for page app bars instead of standard AppBar

  maintainability:

    rule: prefer reusable widgets
    rule: avoid duplicated code
    rule: extract shared logic into helpers or usecases

  performance:

    rule: prefer const widgets when possible
    rule: avoid rebuilding large widget trees
    rule: split widgets to control rebuilds
    rule: avoid unnecessary rebuilds in bloc builders

TESTING-STANDARDS:

  unit-testing:
    rule: must write unit tests for UseCases, Blocs, and Repositories

  mocking:
    rule: consistently use your chosen mocking library (e.g., mocktail or mockito) for dependencies

  widget-testing:
    rule: write widget tests for complex standalone UI components

STATE-MANAGEMENT-ADVANCED:

  state-equality:
    rule: use Equatable for all BLoC States and Events to ensure proper value comparison and prevent unnecessary rebuilds

  naming-convention:
    events: Subject + Action (e.g., UserLoginRequested, MedicationAdded)
    states: Feature + Status (e.g., AuthInitial, AuthLoading, AuthSuccess, AuthFailure)

SECURITY-AND-LOGGING:

  secure-storage:
    rule: NEVER store auth tokens, passwords, or PII in SharedPreferences
    action: MUST use flutter_secure_storage for sensitive data

  logging:
    rule: NEVER use print() in production code
    action: use a dedicated Logger service and send critical errors to Firebase Crashlytics

NETWORKING-AND-API:

  interceptors:
    rule: MUST use Dio interceptors to inject Auth Tokens automatically into headers

  session-expiration:
    rule: MUST handle 401 Unauthorized globally and redirect user to Login page

ASSETS-AND-ANIMATIONS:

  asset-management:
    rule: NEVER hardcode asset paths (strings) directly in UI widgets
    action: MUST define all images and icons in lib/core/constants/app_assets.dart

  memory-management:
    rule: ALWAYS dispose AnimationControllers, TextEditingControllers, and ScrollControllers in StatefulWidget dispose()

</rules>

<rhythm>

workflow-new-feature:
  domain → data → presentation → injection_container

error-handling:
  use Either<Failure, Type> from fpdart in repositories and use cases

ui-development:
  follow ui_ux_skill.md for layout, spacing, accessibility, and interaction patterns

flutter-coding:
  follow flutter_skill.md for widget composition, performance optimization, and architecture consistency

</rhythm>

<conn>

database: Hive
local-storage: SharedPreferences
backend: Firebase

</conn>

<ref label="on-demand Read only">

lib/injection_container.dart → dependency registration
lib/core/routes/ → go_router configuration
pubspec.yaml → dependencies and assets

lib/main.dart → app entry point

docs/flutter_skill.md → Flutter development best practices
docs/ui_ux_skill.md → UI/UX design principles

</ref>

<learn>

Adapt to specific domain entities as new features (e.g. auth, home, medication).
Follow existing feature patterns and maintain clean architecture boundaries.
Always respect Flutter and UI/UX skill guidelines when generating code or layouts.

</learn>