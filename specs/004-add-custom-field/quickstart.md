# Quickstart Validation Guide: Add Custom Field Page

## Prerequisites
- Flutter SDK installed
- Supabase local instance running
- Test project with admin permissions

## Validation Scenarios

### Scenario 1: Open/Close Sliding Panel
**Steps**:
1. Navigate to project settings page
2. Tap "Add field" button
3. Verify panel slides in from right (300ms animation)
4. Verify dark overlay appears behind panel
5. Tap overlay outside panel
6. Verify panel slides out and disappears

**Expected Result**: Smooth animation, overlay blocks background interaction, panel closes on overlay tap.

### Scenario 2: Select Field Type
**Steps**:
1. Open add custom field panel
2. View tabbed interface with type options
3. Tap different tabs (build, enum, group, etc.)
4. Verify active tab indicator changes
5. Verify active tab has colored underline
6. Verify inactive tabs are gray

**Expected Result**: Tab selection works, visual feedback immediate, underline animates smoothly.

### Scenario 3: Fill Field Details
**Steps**:
1. Open add custom field panel
2. Enter field name in "Field Name" input
3. Enter description in "Description" input
4. Verify text displays correctly
5. Clear field name
6. Verify "Add field" button remains disabled

**Expected Result**: Form captures input, button disabled when required fields missing.

### Scenario 4: Toggle Privacy Setting
**Steps**:
1. Open add custom field panel
2. Locate "Make private" checkbox
3. Verify bold label and helper text visible
4. Tap checkbox
5. Verify checkbox toggles state

**Expected Result**: Checkbox works, visual design matches specification.

### Scenario 5: Submit Custom Field
**Steps**:
1. Open add custom field panel
2. Fill all required fields (name, type)
3. Tap "Add field" button
4. Verify panel closes
5. Navigate to project settings
6. Verify new field appears in list

**Expected Result**: Field created successfully, appears in project field list.

### Scenario 6: Validation and Error Handling
**Steps**:
1. Try to create field with existing name
2. Verify uniqueness validation error
3. Try to create field with invalid characters
4. Verify format validation error
5. Disconnect network
6. Try to create field
7. Verify network error message

**Expected Result**: Appropriate error messages, graceful handling.

### Scenario 7: Animation Performance
**Steps**:
1. Open/close panel multiple times
2. Switch between tabs rapidly
3. Fill form while animation running
4. Test on low-end device

**Expected Result**: Smooth 60fps animations, no frame drops.

## Running Tests

### Unit Tests
```bash
flutter test test/unit/custom_field/
```

### Widget Tests
```bash
flutter test test/widget/custom_field/
```

### Integration Tests
```bash
flutter test integration_test/custom_field/
```

## Success Criteria Verification

### SC-001: Panel opens in under 2 seconds
- Measure time from button tap to panel fully open
- Target: < 2 seconds

### SC-002: Smooth animations
- Visual inspection on mid-range device
- No jank or frame drops

### SC-003: 95% success rate
- Test with 20 users creating fields
- Measure completion without assistance

### SC-004: 98% creation success rate
- Monitor error rates in test environment
- Exclude network errors

### SC-005: Immediate tab feedback
- Visual verification of tab switching
- No delay in indicator movement

### SC-006: Panel closes within 300ms
- Measure time from overlay tap to panel fully closed
- Target: < 300ms