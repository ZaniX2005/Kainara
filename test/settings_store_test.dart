import 'package:flutter_test/flutter_test.dart';
import 'package:kainara/data/auth_store.dart';
import 'package:kainara/data/profile_store.dart';
import 'package:kainara/data/settings_store.dart';

void main() {
  test('notification pause preserves the selected notification channels', () {
    final settings = SettingsStore.instance;
    settings.setPauseNotifications(false);
    settings.setMotifNotifications(true);
    settings.setOutfitNotifications(true);

    settings.setPauseNotifications(true);
    expect(settings.motifNotificationsActive, isFalse);
    expect(settings.outfitNotificationsActive, isFalse);

    settings.setPauseNotifications(false);
    expect(settings.motifNotificationsActive, isTrue);
    expect(settings.outfitNotificationsActive, isTrue);
  });

  test('account changes keep the local demo login credentials in sync', () {
    final auth = AuthStore.instance;
    const oldEmail = 'settings-test@kainara.test';
    const newEmail = 'updated-settings-test@kainara.test';
    const newPassword = 'updated-password';

    expect(auth.register('Settings Test', oldEmail, 'old-password'), isTrue);
    expect(auth.updateEmail('not-an-email'), AccountUpdateResult.invalidEmail);
    expect(
      auth.updateEmail('danielle21@gmail.com'),
      AccountUpdateResult.emailAlreadyExists,
    );
    expect(auth.updateEmail(newEmail), AccountUpdateResult.ok);
    expect(ProfileStore.instance.verified, isFalse);
    expect(auth.updatePassword('short'), AccountUpdateResult.weakPassword);
    expect(auth.updatePassword(newPassword), AccountUpdateResult.ok);
    expect(auth.updateName('Updated Settings Test'), isTrue);

    auth.logout();
    expect(auth.login(oldEmail, 'old-password'), AuthResult.emailNotFound);
    expect(auth.login(newEmail, 'old-password'), AuthResult.wrongPassword);
    expect(auth.login(newEmail, newPassword), AuthResult.ok);
    expect(ProfileStore.instance.name, 'Updated Settings Test');
    auth.logout();
  });
}
