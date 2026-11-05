package me.zhuyaing.jujutsu;

import me.zhuyaing.jujutsu.element.JujutsuTechniqueElement;
import me.zhuyaing.jujutsu.ui.JujutsuTechniqueGUI;
import me.zhuyaing.jujutsu.util.DependencyNames;
import me.zhuyaing.jujutsu.util.DependencyWatcher;
import freemarker.template.Template;
import net.mcreator.element.GeneratableElement;
import net.mcreator.element.ModElementType;
import net.mcreator.element.ModElementTypeLoader;
import net.mcreator.generator.GeneratorTokens;
import net.mcreator.generator.template.InlineTemplatesHandler;
import net.mcreator.generator.template.base.BaseDataModelProvider;
import net.mcreator.io.FileIO;
import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.PluginLoader;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import net.mcreator.plugin.events.ui.ModElementGUIEvent;
import net.mcreator.plugin.events.workspace.MCreatorLoadedEvent;
import net.mcreator.plugin.events.workspace.WorkspaceBuildStartedEvent;
import net.mcreator.plugin.events.workspace.WorkspaceSavedEvent;
import net.mcreator.workspace.Workspace;
import net.mcreator.workspace.elements.ModElement;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class JujutsuPlugin extends JavaPlugin {
	private static final Logger LOG = LogManager.getLogger("JujutsuPlugin");
	private static final String PROC_DEPS_META = "_jujutsuProcDepsSig";
	private static final String TYPE_CURSED_TECHNIQUE = "cursed_technique";
	private static final String MIXIN_GRADLE = "mixin.gradle";
	private static final String MIXIN_APPLY_MARKER = "apply from: 'mixin.gradle'";
	private static final String MIXIN_APPLY_LINE = "\nif (file(\"mixin.gradle\").exists())\n    apply from: 'mixin.gradle'\n";

	private static final String API_MODID = "jujutsucraft";
	private static final String API_GENERATOR = "forge-1.20.1";
	private static final String API_TEMPLATE_DIR = API_GENERATOR + "/templates/";

	private static final String[][] API_SOURCES = { { "api/jujutsucraft.java.ftl", "@SRCROOT/@BASEPACKAGEPATH/apis/JujutsuCraft.java" },
			{ "api/jujutsuplayerdata.java.ftl", "@SRCROOT/@BASEPACKAGEPATH/apis/JujutsuPlayerData.java" },
			{ "api/jujutsucurseddata.java.ftl", "@SRCROOT/@BASEPACKAGEPATH/apis/JujutsuCursedData.java" },
			{ "api/impl/jujutsuplayerdataimpl.java.ftl", "@SRCROOT/@BASEPACKAGEPATH/apis/impl/JujutsuPlayerDataImpl.java" },
			{ "api/impl/jujutsucurseddataimpl.java.ftl", "@SRCROOT/@BASEPACKAGEPATH/apis/impl/JujutsuCursedDataImpl.java" } };

	public JujutsuPlugin(Plugin plugin) {
		super(plugin);

		addListener(PreGeneratorsLoadingEvent.class, _ -> ModElementTypeLoader.register(new ModElementType<>("cursed_technique", null, JujutsuTechniqueGUI::new, JujutsuTechniqueElement.class)));

		addListener(WorkspaceSavedEvent.AfterSaving.class, event -> {
			refreshTechniques(event.getWorkspace());
			ensureMixinGradleApplied(event.getWorkspace().getWorkspaceFolder());
			ensureApiSources(event.getWorkspace());
		});

		addListener(WorkspaceBuildStartedEvent.class, event -> {
			refreshTechniques(event.getMCreator().getWorkspace());
			ensureMixinGradleApplied(event.getMCreator().getWorkspaceFolder());
			ensureApiSources(event.getMCreator().getWorkspace());
		});

		addListener(MCreatorLoadedEvent.class, event -> {
			ensureMixinGradleApplied(event.getMCreator().getWorkspaceFolder());
			ensureApiSources(event.getMCreator().getWorkspace());
		});

		addListener(ModElementGUIEvent.WhenSaving.class, event -> ensureApiSources(event.getMCreator().getWorkspace()));

		LOG.info("plugin was loaded");
	}

	private void ensureMixinGradleApplied(File workspaceFolder) {
		File buildGradle = new File(workspaceFolder, "build.gradle");
		if (!buildGradle.isFile() || !new File(workspaceFolder, MIXIN_GRADLE).isFile()) return;
		if (FileIO.readFileToString(buildGradle).contains(MIXIN_APPLY_MARKER)) return;

		try {
			Files.writeString(buildGradle.toPath(), MIXIN_APPLY_LINE, StandardOpenOption.CREATE, StandardOpenOption.APPEND);
			LOG.info("Added {} apply line to build.gradle", MIXIN_GRADLE);
		} catch (IOException e) {
			LOG.error("Failed to add {} apply line to build.gradle", MIXIN_GRADLE, e);
		}
	}

	private void ensureApiSources(Workspace workspace) {
		if (workspace == null || workspace.getGenerator() == null) return;
		if (!workspace.getWorkspaceSettings().getMCreatorDependencies().contains(API_MODID)) return;
		if (!API_GENERATOR.equals(workspace.getGenerator().getGeneratorName())) return;

		if (hasCursedTechniqueElement(workspace)) return;

		untrackApiSources(workspace);

		Map<String, Object> dataModel;
		try {
			dataModel = new BaseDataModelProvider(workspace.getGenerator()).provide();
		} catch (RuntimeException e) {
			LOG.error("Failed to build the data model for the JujutsuCraft API sources", e);
			return;
		}

		for (String[] source : API_SOURCES) {
			try {
				writeIfChanged(workspace, source[0], source[1], dataModel);
			} catch (Exception e) {
				LOG.error("Failed to write the JujutsuCraft API source {}", source[0], e);
			}
		}
	}

	private boolean hasCursedTechniqueElement(Workspace workspace) {
		for (ModElement me : workspace.getModElements()) {
			if (TYPE_CURSED_TECHNIQUE.equals(me.getTypeString())) return true;
		}
		return false;
	}

	private void untrackApiSources(Workspace workspace) {
		if (!(workspace.getMetadata("files") instanceof List<?> files)) return;

		List<String> kept = new ArrayList<>();
		boolean changed = false;
		for (Object entry : files) {
			if (entry != null && isApiSourcePath(entry.toString())) {
				changed = true;
			} else if (entry != null) {
				kept.add(entry.toString());
			}
		}
		if (!changed) return;

		workspace.putMetadata("files", kept);
		LOG.info("Removed the JujutsuCraft API sources from the generated files metadata");
	}

	private static boolean isApiSourcePath(String path) {
		String normalized = path.replace('\\', '/');
		for (String[] source : API_SOURCES) {
			if (normalized.endsWith("/apis/" + apiSourceSuffix(source[1]))) return true;
		}
		return false;
	}

	private static String apiSourceSuffix(String targetToken) {
		int marker = targetToken.indexOf("/apis/");
		return marker < 0 ? targetToken : targetToken.substring(marker + "/apis/".length());
	}

	private void writeIfChanged(Workspace workspace, String template, String targetToken, Map<String, Object> dataModel)
			throws Exception {
		String templateCode;
		try (InputStream stream = PluginLoader.INSTANCE.getResourceAsStream(API_TEMPLATE_DIR + template)) {
			if (stream == null) {
				LOG.error("Missing JujutsuCraft API template resource {}", template);
				return;
			}
			templateCode = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
		}

		Template tpl = InlineTemplatesHandler.getTemplate(templateCode);
		StringWriter writer = new StringWriter();
		tpl.process(dataModel, writer, InlineTemplatesHandler.getConfiguration().getObjectWrapper());
		String code = writer.toString();

		File target = new File(GeneratorTokens.replaceTokens(workspace, targetToken));
		if (!workspace.getFolderManager().isFileInWorkspace(target)) return;
		if (target.isFile() && FileIO.readFileToString(target).equals(code)) return;

		FileIO.writeStringToFile(code, target);
		LOG.info("Wrote JujutsuCraft API source {}", workspace.getFolderManager().getPathInWorkspace(target));
	}

	private void refreshTechniques(Workspace workspace) {
		for (ModElement me : new ArrayList<>(workspace.getModElements())) {
			if (!TYPE_CURSED_TECHNIQUE.equals(me.getTypeString())) continue;
			GeneratableElement ge = me.getGeneratableElement();
			if (!(ge instanceof JujutsuTechniqueElement technique)) continue;

			normalizeSkillCase(workspace, technique);
			refreshTechniqueIfReferencedProcsChanged(workspace, me, technique);
		}
	}

	private void normalizeSkillCase(Workspace workspace, JujutsuTechniqueElement technique) {
		double skillCase = JujutsuTechniqueElement.effectiveSkillCase(technique.skillCase);
		if (skillCase == technique.skillCase) return;
		technique.skillCase = skillCase;
		workspace.getModElementManager().storeModElement(technique);
		LOG.info("Normalized skill case of {} to {}", technique.getModElement().getName(), skillCase);
	}

	private void refreshTechniqueIfReferencedProcsChanged(Workspace workspace, ModElement me, JujutsuTechniqueElement technique) {
		DependencyWatcher.regenerateIfChanged(workspace, me, PROC_DEPS_META, referencedProcDepsSignature(workspace, technique), technique);
	}

	private String referencedProcDepsSignature(Workspace workspace, JujutsuTechniqueElement technique) {
		List<String> parts = new ArrayList<>();
		for (JujutsuTechniqueElement.TechniqueSlot slot : technique.slots) {
			addProcSig(workspace, slot.procedure, parts);
		}
		return String.join(";", parts);
	}

	private void addProcSig(Workspace workspace, net.mcreator.element.parts.procedure.Procedure proc, List<String> parts) {
		if (proc == null || proc.getName() == null) return;
		parts.add(DependencyNames.signature(workspace, proc.getName()));
	}
}
