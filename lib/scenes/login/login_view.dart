import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({required this.viewModel, super.key});

  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => AppScaffold(
        showAppBar: false,
        body: Center(
          child: SingleChildScrollView(
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: AppRadius.lgAll,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.speed_rounded,
                        size: 36,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const Gap.md(),
                  Text(
                    'FINDRIVE',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Gap.xxs(),
                  Text(
                    'Gestão Financeira & Metas Inteligentes',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap.xl(),
                  AppTextField(
                    key: const Key('login_email'),
                    label: 'E-mail do motorista',
                    hint: 'ex: motorista@findrive.app',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.mail_outline,
                    autofillHints: const [AutofillHints.email],
                    onChanged: viewModel.onEmailChanged,
                  ),
                  const Gap.md(),
                  PasswordField(
                    key: const Key('login_password'),
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onChanged: viewModel.onPasswordChanged,
                  ),
                  if (viewModel.errorMessage != null) ...[
                    const Gap.sm(),
                    Text(
                      viewModel.errorMessage!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Gap.xl(),
                  AppButton(
                    key: const Key('login_submit'),
                    label: 'Entrar no FINDRIVE',
                    isLoading: viewModel.isLoading,
                    onPressed: () => viewModel.submit(context),
                  ),
                  const Gap.md(),
                  AppButton.secondary(
                    label: 'Acesso Rápido Demonstração',
                    onPressed: () {
                      viewModel.onEmailChanged('carlos.motorista@findrive.app');
                      viewModel.onPasswordChanged('123456');
                      viewModel.submit(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
