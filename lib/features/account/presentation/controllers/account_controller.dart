import 'package:get/get.dart';

import '../../../../core/services/app_auth_service.dart';
import '../../../../data/models/birth_profile.dart';
import '../../../../data/models/wallet_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../data/repositories/wallet_repository.dart';

class AccountController extends GetxController {
  AccountController(
    this._chartRepository,
    this._walletRepository,
    this._authService,
  );

  final ChartRepository _chartRepository;
  final WalletRepository _walletRepository;
  final AppAuthService _authService;

  final Rxn<BirthProfile> mainProfile = Rxn<BirthProfile>();
  final Rxn<WalletSnapshot> wallet = Rxn<WalletSnapshot>();
  final Rxn<AuthSession> session = Rxn<AuthSession>();

  @override
  void onInit() {
    super.onInit();
    session.value = _authService.currentSession();
    _authService.authStateChanges().listen((AuthSession? value) {
      session.value = value;
    });
    _load();
  }

  Future<void> _load() async {
    mainProfile.value = await _chartRepository.getMainProfile();
    wallet.value = await _walletRepository.getWallet();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
