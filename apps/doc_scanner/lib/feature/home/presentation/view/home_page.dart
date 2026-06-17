import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:doc_scanner/constants/value_const.dart';
import 'package:core/core/di/core_injection.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/ui/molecules/bottom_sheet.dart';
import '../bloc/doc_scanner_bloc.dart';
import '../bloc/model_selector_cubit.dart';
import '../widgets/model_selector_sheet.dart';
import 'home_screen.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
        create: (_) => ModelSelectorCubit(
          getSelectedModelUseCase: sl(),
          selectModelUseCase: sl(),
          getApiKeysUseCase: sl(),
          saveApiKeyUseCase: sl(),
        ),
        child: child,
      );

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(
        title: ValueConst.docScannerAppBarTitle,
        actions: [
          IconButton(
            tooltip: ValueConst.docScannerModelSelectorTooltip,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => AppBottomSheet.show(
              context,
              title: ValueConst.docScannerModelSelectorTitle,
              child: BlocProvider.value(
                value: context.read<ModelSelectorCubit>(),
                child: const ModelSelectorSheetContent(),
              ),
            ),
          ),
        ],
      );

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
        create: (_) => DocScannerBloc(
          resolveImageUseCase: sl(),
          scanReceiptUseCase: sl(),
          generatePdfUseCase: sl(),
          loadReceiptsUseCase: sl(),
          saveReceiptUseCase: sl(),
          editReceiptUseCase: sl(),
          deleteReceiptUseCase: sl(),
          modelSelectorCubit: context.read<ModelSelectorCubit>(),
        )..add(const DocScannerEvent.started()),
        child: const HomeScreen(),
      );
}
