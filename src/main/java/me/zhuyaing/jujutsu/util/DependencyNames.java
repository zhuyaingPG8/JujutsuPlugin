package me.zhuyaing.jujutsu.util;

import net.mcreator.blockly.data.Dependency;
import net.mcreator.workspace.Workspace;
import net.mcreator.workspace.elements.ModElement;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public final class DependencyNames {
	public static final String METADATA_KEY = "dependencies";

	public static List<String> of(Object metadata) {
		List<String> names = new ArrayList<>();
		if (metadata instanceof List<?> list) {
			for (Object entry : list) {
				String name = extract(entry);
				if (name != null) names.add(name);
			}
		}
		return names;
	}

	public static String signature(Workspace workspace, String procedureName) {
		ModElement me = ProcedureMeta.resolve(workspace, procedureName);
		String deps = me != null ? String.join(",", of(me.getMetadata(METADATA_KEY))) : "";
		return procedureName + ":" + deps;
	}

	private static String extract(Object entry) {
		if (entry instanceof Dependency dependency)
			return dependency.getName();
		if (entry instanceof Map<?, ?> map) {
			Object name = map.get("name");
			if (name != null) return name.toString();
		}
		return null;
	}
}
