package me.zhuyaing.jujutsu.util;

import net.mcreator.workspace.Workspace;
import net.mcreator.workspace.elements.ModElement;
import net.mcreator.workspace.elements.VariableTypeLoader;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public final class ProcedureMeta {
	public static final String METADATA_RETURN_TYPE = "return_type";

	private static final Logger LOG = LogManager.getLogger("JujutsuPlugin");
	private static final Set<String> WARNED = ConcurrentHashMap.newKeySet();

	public static String returnTypeOf(ModElement modElement) {
		if (modElement == null) return null;
		Object meta = modElement.getMetadata(METADATA_RETURN_TYPE);
		return meta != null ? meta.toString() : null;
	}

	public static String returnTypeOf(Workspace workspace, String procedureName) {
		return returnTypeOf(resolve(workspace, procedureName));
	}

	public static boolean hasReturnValue(Workspace workspace, String procedureName) {
		String returnType = returnTypeOf(workspace, procedureName);
		if (returnType == null) return false;
		try {
			if (VariableTypeLoader.INSTANCE.fromName(returnType) != null) return true;
		} catch (Exception e) {
			LOG.debug("Could not resolve return type '{}' of procedure {}", returnType, procedureName, e);
		}
		if (WARNED.add(procedureName + "|" + returnType))
			LOG.warn("Unresolvable return type '{}' of procedure {}; treating it as void", returnType, procedureName);
		return false;
	}

	public static ModElement resolve(Workspace workspace, String procedureName) {
		if (workspace == null || procedureName == null || procedureName.isEmpty()) return null;
		return workspace.getModElementByName(procedureName);
	}
}
