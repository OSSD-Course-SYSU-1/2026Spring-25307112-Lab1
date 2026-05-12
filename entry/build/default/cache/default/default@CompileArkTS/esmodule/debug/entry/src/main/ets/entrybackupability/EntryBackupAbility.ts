import hilog from "@ohos:hilog";
import BackupExtensionAbility from "@ohos:application.BackupExtensionAbility";
import type { BundleVersion } from "@ohos:application.BackupExtensionAbility";
const LOG_DOMAIN_BACKUP = 0x0000;
export default class EntryBackupAbility extends BackupExtensionAbility {
    onBackup() {
        hilog.info(LOG_DOMAIN_BACKUP, 'testTag', 'onBackup ok');
    }
    onRestore(bundleVersion: BundleVersion) {
        hilog.info(LOG_DOMAIN_BACKUP, 'testTag', 'onRestore ok %{public}s', JSON.stringify(bundleVersion));
    }
}
