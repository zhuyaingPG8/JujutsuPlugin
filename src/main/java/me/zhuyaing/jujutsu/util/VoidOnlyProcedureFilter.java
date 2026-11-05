package me.zhuyaing.jujutsu.util;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.SearchableComboBox;
import net.mcreator.ui.procedure.AbstractProcedureSelector;
import net.mcreator.ui.procedure.ProcedureSelector;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.swing.*;
import javax.swing.event.PopupMenuEvent;
import java.lang.reflect.Field;
import java.util.List;

public final class VoidOnlyProcedureFilter {
    private static final Logger LOG = LogManager.getLogger("JujutsuPlugin");
    private static final String INSTALLED_KEY = "jujutsu.voidOnlyFilter.installed";

    public static void install(MCreator mcreator, ProcedureSelector selector, String where) {
        try {
            Field f = AbstractProcedureSelector.class.getDeclaredField("procedures");
            f.setAccessible(true);
            SearchableComboBox<?> combo = (SearchableComboBox<?>) f.get(selector);
            if (Boolean.TRUE.equals(combo.getClientProperty(INSTALLED_KEY))) return;
            combo.putClientProperty(INSTALLED_KEY, Boolean.TRUE);
            install(mcreator, selector, combo, where);
        } catch (Exception e) {
            LOG.warn("Could not install the void-only filter on {}", where, e);
        }
    }

    private static void install(MCreator mcreator, ProcedureSelector selector, SearchableComboBox<?> combo, String where) {
        final boolean[] rejecting = { false };
        AbstractProcedureSelector.ReloadContext context = AbstractProcedureSelector.ReloadContext.create(mcreator.getWorkspace());
        combo.addPopupMenuListener(new PopupMenuAdapter() {
            public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
                dropNonVoidItems(mcreator, combo, where);
            }

            public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
                selector.refreshListKeepSelected(context);
            }
        });
        combo.addActionListener(_ -> {
            if (rejecting[0]) return;
            Object sel = combo.getSelectedItem();
            if (sel == null || !ProcedureMeta.hasReturnValue(mcreator.getWorkspace(), sel.toString())) return;
            LOG.warn("Rejected non-void procedure '{}' in {}; cleared to placeholder", sel, where);
            rejecting[0] = true;
            try {
                if (combo.getModel().getSize() > 0)
                    combo.setSelectedItem(combo.getModel().getElementAt(0));
            } finally {
                rejecting[0] = false;
            }
        });
    }

    private static void dropNonVoidItems(MCreator mcreator, SearchableComboBox<?> combo, String where) {
        MutableComboBoxModel<?> model = (MutableComboBoxModel<?>) combo.getModel();
        if (model.getSize() == 0) return;
        Object selected = model.getSelectedItem();
        boolean removedSelected = false;
        for (int i = model.getSize() - 1; i >= 1; i--) {
            Object entry = model.getElementAt(i);
            if (entry == null) continue;
            if (!ProcedureMeta.hasReturnValue(mcreator.getWorkspace(), entry.toString())) continue;
            if (entry.equals(selected)) {
                removedSelected = true;
                LOG.warn("Cleared non-void procedure '{}' from {}", entry, where);
            }
            model.removeElementAt(i);
        }
        pruneSearchableEntries(mcreator, combo);
        if (removedSelected || model.getSelectedItem() == null
                || ProcedureMeta.hasReturnValue(mcreator.getWorkspace(), String.valueOf(model.getSelectedItem())))
            model.setSelectedItem(model.getElementAt(0));
    }

    @SuppressWarnings("unchecked") private static void pruneSearchableEntries(MCreator mcreator, SearchableComboBox<?> combo) {
        try {
            Field f = SearchableComboBox.class.getDeclaredField("entries");
            f.setAccessible(true);
            List<Object> entries = (List<Object>) f.get(combo);
            if (entries == null) return;
            int before = entries.size();
            entries.removeIf(e -> e != null && ProcedureMeta.hasReturnValue(mcreator.getWorkspace(), e.toString()));
            if (entries.size() != before)
                LOG.debug("Pruned {} non-void entr(ies) from the SearchableComboBox copy", before - entries.size());
        } catch (Throwable t) {
            LOG.warn("Could not prune SearchableComboBox.entries; the popup may keep showing removed items", t);
        }
    }
}
