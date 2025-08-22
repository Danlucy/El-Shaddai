import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:mobile/core/organization/controller/organization_controller.dart';

class OrganizationSelectionDropdown extends ConsumerWidget {
  // Use a nullable type to represent the state where nothing is selected yet.
  OrganizationsID? _selectedOrg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassmorphicContainer(
      width: 300,
      height: 60,
      borderRadius: 12,
      blur: 10, // The blur intensity
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpac(0.2), Colors.white.withOpac(0.1)],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpac(0.5), Colors.white.withOpac(0.5)],
      ),
      child: DropdownButtonHideUnderline(
        // By default, the dropdown menu's width is determined by the widest item.
        // Wrapping it in a SizedBox ensures the menu width matches the button's width.
        child: SizedBox(
          width: 300, // This should match the parent container's width
          child: DropdownButton<OrganizationsID>(
            // --- Styling ---
            value: ref.watch(organizationControllerProvider).value,
            isExpanded: true,
            iconSize: 0,
            hint: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Select an Organization',
                style: TextStyle(fontSize: 16, color: context.colors.primary),
              ),
            ),
            dropdownColor: Colors.black.withOpac(0.7),
            // This property makes the dropdown menu's border rounded.
            borderRadius: BorderRadius.circular(12),

            // --- Logic ---
            onChanged: (OrganizationsID? newValue) {
              if (newValue == null) {
                throw 'Organization not  selected'; // Handle null case
              }
              ref
                  .read(organizationControllerProvider.notifier)
                  .updateOrg(newValue);
            },
            // --- Generating Items from the Enum ---
            items: OrganizationsID.values
                .map<DropdownMenuItem<OrganizationsID>>((
                  OrganizationsID value,
                ) {
                  return DropdownMenuItem<OrganizationsID>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        value.displayName, // Use the user-friendly name
                        style: TextStyle(
                          fontSize: 16,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ),
      ),
    );
  }
}
