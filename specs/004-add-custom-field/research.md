# Research: Add Custom Field Page

## Technical Decisions

### 1. Animation Implementation
**Decision**: Use Flutter's built-in `AnimatedPositioned` widget with `Stack` for sliding panel.
**Rationale**: Native Flutter animations provide smooth 60fps performance, simple API, and no external dependencies. The 300ms duration meets UX requirements.
**Alternatives considered**: 
- `AnimationController` with custom tween: More control but more boilerplate.
- Third-party animation libraries: Unnecessary dependency for simple sliding.

### 2. Overlay Implementation
**Decision**: Use `AnimatedOpacity` with `GestureDetector` for dark transparent overlay.
**Rationale**: Simple implementation that meets requirement for tap-to-close behavior. `AnimatedOpacity` provides smooth fade-in/out.
**Alternatives considered**:
- `ModalBarrier`: More semantic but less control over opacity animation.
- Custom overlay widget: Over-engineered for this use case.

### 3. Tabbed Interface
**Decision**: Custom `Row` with `Text` widgets and underline indicator using `Container`.
**Rationale**: Matches exact design specifications without external tab library. Full control over styling and animation.
**Alternatives considered**:
- `TabBar` widget: Default Material design doesn't match custom design requirements.
- Third-party tab packages: Unnecessary dependency.

### 4. State Management
**Decision**: Use `Cubit` for form state (panel open/close, selected tab, form fields).
**Rationale**: Simple state management for form interactions without complex event handling. Aligns with constitution's State Management Discipline.
**Alternatives considered**:
- `BLoC`: More ceremony than needed for simple form state.
- `ValueNotifier`: Less structured, harder to test.

### 5. Backend Integration
**Decision**: Use Supabase client with typed queries via existing repository pattern.
**Rationale**: Follows Supabase Backend Governance principles. Existing infrastructure and patterns in codebase.
**Alternatives considered**:
- Direct HTTP calls: Bypasses Supabase client benefits.
- Custom API layer: Unnecessary abstraction.

### 6. Form Validation
**Decision**: Validate at domain layer before persistence, with UI feedback.
**Rationale**: Constitution requires domain-layer validation. Provides immediate user feedback.
**Alternatives considered**:
- Database-level validation only: Poor user experience.
- UI-only validation: Inconsistent across features.

### 7. Error Handling
**Decision**: Graceful network error handling with user-friendly messages.
**Rationale**: Constitution requires informing users of connectivity issues without exposing stack traces.
**Alternatives considered**:
- Silent retry: May frustrate users.
- Technical error messages: Not user-friendly.

### 8. Testing Strategy
**Decision**: TDD with widget tests for UI interactions, unit tests for business logic, integration tests for critical paths.
**Rationale**: Constitution requires Test-First Development and minimum test coverage.
**Alternatives considered**:
- Manual testing only: Insufficient for automated CI.
- Test-after approach: Violates TDD principle.

## Implementation Patterns

### Existing Codebase Patterns to Reuse
1. Feature-first architecture with data/domain/presentation layers
2. Repository pattern with interface in domain, implementation in data
3. Cubit for simple state management
4. Supabase client for backend operations
5. Widget tests with mockito for mocking

### New Patterns to Introduce
1. Animated sliding panel component (reusable)
2. Custom tab indicator widget (reusable)
3. Form validation helpers

## Risks and Mitigations

### Risk: Animation performance on low-end devices
**Mitigation**: Use `const` constructors, minimize rebuilds, test on target devices.

### Risk: Complex form state management
**Mitigation**: Keep Cubit simple, delegate business logic to use cases.

### Risk: Supabase migration complexity
**Mitigation**: Follow existing migration patterns, test locally before merge.

## Dependencies

### Existing Dependencies (already in pubspec.yaml)
- `flutter_bloc`: State management
- `equatable`: Value equality
- `get_it`: Dependency injection
- `supabase_flutter`: Backend integration
- `go_router`: Navigation
- `intl`: Localization

### No New Dependencies Required
All functionality can be achieved with existing dependencies.