package me.zhuyaing.jujutsu.util;

import net.mcreator.element.GeneratableElement;
import net.mcreator.workspace.Workspace;
import net.mcreator.workspace.elements.ModElement;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public final class DependencyWatcher {
	private static final Logger LOG = LogManager.getLogger("JujutsuPlugin");

	public static boolean regenerateIfChanged(Workspace workspace, ModElement me, String metadataKey, String currentSignature, GeneratableElement target) {
		String stored = (String) me.getMetadata(metadataKey);
		if (stored == null) {
			me.putMetadata(metadataKey, currentSignature);
			return false;
		}
		if (currentSignature.equals(stored)) return false;
		try {
			if (workspace.getGenerator() != null) workspace.getGenerator().generateElement(target);
			me.putMetadata(metadataKey, currentSignature);
			LOG.info("Regenerated technique {} because a referenced procedure's dependencies changed", me.getName());
			return true;
		} catch (Exception e) {
			LOG.warn("Failed to regenerate technique {}: {}", me.getName(), e.toString());
			return false;
		}
	}
}
