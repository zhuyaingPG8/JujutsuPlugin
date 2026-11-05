package me.zhuyaing.jujutsu.ui;

import me.zhuyaing.jujutsu.element.JujutsuTechniqueElement;
import me.zhuyaing.jujutsu.ui.form.Fields;
import me.zhuyaing.jujutsu.ui.form.FormPanel;
import me.zhuyaing.jujutsu.util.NumberFields;
import me.zhuyaing.jujutsu.util.VoidOnlyProcedureFilter;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.ui.procedure.AbstractProcedureSelector;
import net.mcreator.ui.procedure.ProcedureSelector;
import net.mcreator.ui.validation.component.VTextField;
import net.mcreator.ui.validation.validators.TextFieldValidator;
import net.mcreator.workspace.elements.ModElement;
import org.jspecify.annotations.Nullable;

import javax.swing.*;
import java.awt.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class JujutsuTechniqueGUI extends ModElementGUI<JujutsuTechniqueElement> {
	private static final double SLOT_MIN = 3;
	private static final double SLOT_MAX = 20;
	private static final String PROCEDURE_DEPENDENCIES = "world:world/x:number/y:number/z:number/entity:entity";

	private final VTextField sorcererIdField = Fields.text(26);
	private final VTextField skillCaseField = Fields.text(14);
	private final Map<Double, SlotRow> slotRows = new LinkedHashMap<>();

	public JujutsuTechniqueGUI(MCreator mcreator, ModElement modElement, boolean editingMode) {
		super(mcreator, modElement, editingMode);
		this.initGUI();
		super.finalizeGUI();
	}

	protected void initGUI() {
		buildSettingsPage();

		sorcererIdField.setValidator(new TextFieldValidator(sorcererIdField, L10N.t("jujutsu.gui.sorcerer_id_required")));
		sorcererIdField.enableRealtimeValidation();
		skillCaseField.setValidator(new TextFieldValidator(skillCaseField, L10N.t("jujutsu.gui.skill_case_required")));
		skillCaseField.enableRealtimeValidation();
	}

	private void buildSettingsPage() {
		JPanel top = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 0));
		top.setBorder(BorderFactory.createEmptyBorder(15, 0, 0, 0));
		top.add(Fields.label("jujutsu.gui.sorcerer_id"));
		top.add(sorcererIdField);
		top.add(Fields.label("jujutsu.gui.skill_case"));
		top.add(skillCaseField);

		JPanel slots = FormPanel.builder()
				.title("jujutsu.gui.slots_title")
				.insets(2, 4, 2, 4)
				.anchor(GridBagConstraints.WEST)
				.columns(FormPanel.Column.fixed(), FormPanel.Column.fixed(), FormPanel.Column.growing(0.4),
						FormPanel.Column.fixed(), FormPanel.Column.fixed(), FormPanel.Column.fixed(),
						FormPanel.Column.growing(1))
				.row(Fields.headerLabel("jujutsu.gui.slot_enable"), Fields.headerLabel("jujutsu.gui.col_slot"),
						Fields.headerLabel("jujutsu.gui.col_name"), Fields.headerLabel("jujutsu.gui.col_cost"),
						Fields.headerLabel("jujutsu.gui.slot_passive"), Fields.headerLabel("jujutsu.gui.slot_physical"),
						Fields.headerLabel("jujutsu.gui.col_procedure"))
				.rows((int) SLOT_MIN, (int) SLOT_MAX, s -> {
					SlotRow slotRow = new SlotRow(s);
					slotRows.put((double) s, slotRow);
					return new Component[] { slotRow.checkbox, slotRow.slotLabel, slotRow.nameField, slotRow.costField,
							slotRow.passiveBox, slotRow.physicalBox, slotRow.selector };
				})
				.build();

		JPanel main = new JPanel(new BorderLayout(10, 10));
		main.add("North", top);
		main.add("Center", slots);

		addPage(L10N.t("jujutsu.gui.page_settings"), main);
	}

	public void reloadDataLists() {
		super.reloadDataLists();
		AbstractProcedureSelector.ReloadContext context = AbstractProcedureSelector.ReloadContext.create(
				mcreator.getWorkspace());
		for (SlotRow row : slotRows.values()) {
			row.selector.refreshListKeepSelected(context);
		}
	}

	protected void openInEditingMode(JujutsuTechniqueElement generatableElement) {
		sorcererIdField.setText(NumberFields.format(generatableElement.sorcererId));
		skillCaseField.setText(NumberFields.format(JujutsuTechniqueElement.effectiveSkillCase(generatableElement.skillCase)));
		for (JujutsuTechniqueElement.TechniqueSlot skillSlot : generatableElement.slots) {
			SlotRow row = slotRows.get(skillSlot.slot);
			if (row != null) {
				row.checkbox.setSelected(skillSlot.enabled);
				row.nameField.setText(skillSlot.name);
				row.costField.setText(String.valueOf(skillSlot.cost));
				row.passiveBox.setSelected(skillSlot.passive);
				row.physicalBox.setSelected(skillSlot.physical);
				row.setEnabledState(skillSlot.enabled);
				if (skillSlot.procedure != null) {
					row.selector.setSelectedProcedure(skillSlot.procedure);
				}
			}
		}
	}

	public JujutsuTechniqueElement getElementFromGUI() {
		JujutsuTechniqueElement jujutsuTechniqueElement = new JujutsuTechniqueElement(modElement);
		jujutsuTechniqueElement.sorcererId = NumberFields.parse(sorcererIdField.getText(), 0);
		jujutsuTechniqueElement.skillCase = NumberFields.parse(skillCaseField.getText(),
				JujutsuTechniqueElement.DEFAULT_SKILL_CASE);
		jujutsuTechniqueElement.slots = new ArrayList<>();
		for (SlotRow row : slotRows.values()) {
			if (row.checkbox.isSelected()) {
				JujutsuTechniqueElement.TechniqueSlot skillSlot = new JujutsuTechniqueElement.TechniqueSlot(row.slot);
				skillSlot.enabled = true;
				skillSlot.name = row.nameField.getText().trim();
				skillSlot.cost = NumberFields.parse(row.costField.getText(), 0);
				skillSlot.passive = row.passiveBox.isSelected();
				skillSlot.physical = row.physicalBox.isSelected();
				skillSlot.procedure = row.selector.getSelectedProcedure();
				jujutsuTechniqueElement.slots.add(skillSlot);
			}
		}
		return jujutsuTechniqueElement;
	}

	public @Nullable URI contextURL() throws URISyntaxException {
		return null;
	}

	private class SlotRow {
		final double slot;
		final JCheckBox checkbox = L10N.checkbox("jujutsu.gui.slot_enable");
		final JLabel slotLabel = new JLabel();
		final VTextField nameField = new VTextField(7);
		final VTextField costField = new VTextField(8);
		final JCheckBox passiveBox = L10N.checkbox("jujutsu.gui.slot_passive");
		final JCheckBox physicalBox = L10N.checkbox("jujutsu.gui.slot_physical");
		final ProcedureSelector selector;

		SlotRow(double slot) {
			this.slot = slot;
			slotLabel.setText(L10N.t("jujutsu.gui.slot_label", String.valueOf(slot)));
			selector = Fields.procedureSelector(mcreator, L10N.t("jujutsu.gui.skill_label", String.valueOf(slot)),
					PROCEDURE_DEPENDENCIES);
			setEnabledState(false);
			checkbox.addActionListener(e -> setEnabledState(checkbox.isSelected()));
			VoidOnlyProcedureFilter.install(mcreator, selector, "a technique slot");
		}

		void setEnabledState(boolean enabled) {
			nameField.setEnabled(enabled);
			costField.setEnabled(enabled);
			passiveBox.setEnabled(enabled);
			physicalBox.setEnabled(enabled);
			selector.setEnabled(checkbox.isSelected());
		}
	}
}
