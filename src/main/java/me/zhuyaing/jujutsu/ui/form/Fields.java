package me.zhuyaing.jujutsu.ui.form;

import net.mcreator.blockly.data.Dependency;
import net.mcreator.minecraft.DataListEntry;
import net.mcreator.minecraft.DataListLoader;
import net.mcreator.minecraft.ElementUtil;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.minecraft.DataListComboBox;
import net.mcreator.ui.minecraft.MCItemHolder;
import net.mcreator.ui.procedure.ProcedureSelector;
import net.mcreator.ui.validation.component.VTextField;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public final class Fields {
	public static JLabel label(String key, Object... parameters) {
		return L10N.label(key, parameters);
	}

	public static JLabel headerLabel(String key, Object... parameters) {
		JLabel label = L10N.label(key, parameters);
		label.setFont(label.getFont().deriveFont(Font.BOLD));
		return label;
	}

	public static JPanel labeled(String key, Component input) {
		JPanel panel = new JPanel(new BorderLayout(6, 0));
		panel.add("West", label(key));
		panel.add("Center", input);
		return panel;
	}

	public static JPanel titled(String key, Component body) {
		JPanel panel = new JPanel(new BorderLayout());
		panel.setBorder(BorderFactory.createTitledBorder(L10N.t(key)));
		panel.add("Center", body);
		return panel;
	}

	public static VTextField text(int columns) {
		return new VTextField(columns);
	}

	public static JCheckBox checkbox(String key, Object... parameters) {
		return L10N.checkbox(key, parameters);
	}

	public static ProcedureSelector procedureSelector(MCreator mcreator, String name, String dependencySpec) {
		return procedureSelector(mcreator, name, Dependency.fromString(dependencySpec));
	}

	public static ProcedureSelector procedureSelector(MCreator mcreator, String name, Dependency... dependencies) {
		return new ProcedureSelector(null, mcreator, name, dependencies);
	}

	public static MCItemHolder itemHolder(MCreator mcreator) {
		return new MCItemHolder(mcreator, ElementUtil::loadBlocksAndItems);
	}

	public static MCItemHolder itemHolder(MCreator mcreator, boolean supportTags) {
		return new MCItemHolder(mcreator, ElementUtil::loadBlocksAndItems, supportTags);
	}

	public static DataListComboBox dataListCombo(MCreator mcreator, String dataListName) {
		List<DataListEntry> entries = new ArrayList<>();
		for (DataListEntry entry : DataListLoader.loadDataList(dataListName)) {
			if (entry.isSupportedInWorkspace(mcreator.getWorkspace()))
				entries.add(entry);
		}
		return new DataListComboBox(mcreator, entries);
	}
}
