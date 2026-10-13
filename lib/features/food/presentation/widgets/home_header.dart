import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/food/presentation/bloc/food_list_bloc.dart';

/// Home's yellow header: search bar, log out, and a greeting.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        16,
        AppSpacing.screenHorizontal,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: _SearchField()),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Log out',
                style: IconButton.styleFrom(backgroundColor: AppColors.font2),
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthLogoutRequested()),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.orangeBase,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _greeting(DateTime.now().hour),
            style: textTheme.headlineMedium?.copyWith(color: AppColors.font2),
          ),
          const SizedBox(height: 6),
          Text(
            'What would you like to eat today?',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.orangeBase,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static String _greeting(int hour) {
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField();

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _controller = TextEditingController();

  static const _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.button)),
    borderSide: BorderSide.none,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    setState(() {}); // Show or hide the clear button.
    context.read<FoodListBloc>().add(FoodListSearchChanged(text));
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      textInputAction: TextInputAction.search,
      cursorColor: AppColors.orangeBase,
      decoration: InputDecoration(
        hintText: 'Search',
        isDense: true,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.orangeBase),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: _clear,
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}