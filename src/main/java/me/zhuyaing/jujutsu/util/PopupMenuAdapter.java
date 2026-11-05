package me.zhuyaing.jujutsu.util;

import javax.swing.event.PopupMenuEvent;
import javax.swing.event.PopupMenuListener;

public abstract class PopupMenuAdapter implements PopupMenuListener {
	public void popupMenuWillBecomeVisible(PopupMenuEvent e) {}

	public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {}

	public void popupMenuCanceled(PopupMenuEvent e) {}
}
