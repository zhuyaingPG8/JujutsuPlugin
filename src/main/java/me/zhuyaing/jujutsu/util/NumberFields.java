package me.zhuyaing.jujutsu.util;

public final class NumberFields {
	public static double parse(String text, double defaultValue) {
		try {
			return Double.parseDouble(text.trim());
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	public static String format(double value) {
		if (!Double.isFinite(value)) return Double.toString(value);
		return value == Math.rint(value) ? Long.toString((long) value) : Double.toString(value);
	}
}
