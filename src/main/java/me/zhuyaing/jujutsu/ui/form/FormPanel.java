package me.zhuyaing.jujutsu.ui.form;

import net.mcreator.ui.init.L10N;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.IntFunction;

public final class FormPanel {
	public record Column(int fill, double weightx) {
		public static Column fixed() {
			return new Column(GridBagConstraints.NONE, 0);
		}

		public static Column growing(double weightx) {
			return new Column(GridBagConstraints.HORIZONTAL, weightx);
		}
	}

	public static Builder builder() {
		return new Builder();
	}

	public static final class Builder {
		private final List<Column> columns = new ArrayList<>();
		private final List<Component[]> rows = new ArrayList<>();
		private String titleKey;
		private Insets insets = new Insets(2, 4, 2, 4);
		private int anchor = GridBagConstraints.WEST;

		public Builder title(String l10nKey) {
			this.titleKey = l10nKey;
			return this;
		}

		public Builder insets(int top, int left, int bottom, int right) {
			this.insets = new Insets(top, left, bottom, right);
			return this;
		}

		public Builder anchor(int anchor) {
			this.anchor = anchor;
			return this;
		}

		public Builder columns(Column... columns) {
			this.columns.clear();
            this.columns.addAll(Arrays.asList(columns));
			return this;
		}

		public Builder row(Component... cells) {
			rows.add(cells);
			return this;
		}

		public Builder rows(Component... singleColumnCells) {
			for (Component cell : singleColumnCells)
				rows.add(new Component[] { cell });
			return this;
		}

		public Builder rows(int from, int to, IntFunction<Component[]> rowFactory) {
			for (int i = from; i <= to; i++)
				rows.add(rowFactory.apply(i));
			return this;
		}

		public JPanel build() {
			JPanel panel = new JPanel(new GridBagLayout());
			if (titleKey != null)
				panel.setBorder(BorderFactory.createTitledBorder(L10N.t(titleKey)));

			List<Column> effective = columns.isEmpty() ? equalColumns() : columns;

			GridBagConstraints gbc = new GridBagConstraints();
			gbc.insets = insets;
			gbc.anchor = anchor;

			for (int y = 0; y < rows.size(); y++) {
				Component[] cells = rows.get(y);
				for (int x = 0; x < cells.length && x < effective.size(); x++) {
					Column column = effective.get(x);
					gbc.gridx = x;
					gbc.gridy = y;
					gbc.fill = column.fill();
					gbc.weightx = column.weightx();
					panel.add(cells[x], gbc);
				}
			}
			return panel;
		}

		private List<Column> equalColumns() {
			int widest = 0;
			for (Component[] cells : rows)
				widest = Math.max(widest, cells.length);
			List<Column> equal = new ArrayList<>();
			for (int i = 0; i < widest; i++)
				equal.add(Column.growing(1));
			return equal;
		}
	}
}
