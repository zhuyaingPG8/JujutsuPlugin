package me.zhuyaing.jujutsu.element;

import net.mcreator.element.GeneratableElement;
import net.mcreator.element.parts.procedure.Procedure;
import net.mcreator.workspace.elements.ModElement;
import net.mcreator.workspace.references.ModElementReference;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings({ "unused"})
public class JujutsuTechniqueElement extends GeneratableElement {
    public static final double DEFAULT_SKILL_CASE = 2;
    public double sorcererId = 0;
    public double skillCase = DEFAULT_SKILL_CASE;

    @ModElementReference
    public List<TechniqueSlot> slots = new ArrayList<>();

    public JujutsuTechniqueElement(ModElement element) {
        super(element);
    }

    public static double effectiveSkillCase(double skillCase) {
        return skillCase > 0 ? skillCase : DEFAULT_SKILL_CASE;
    }

    public static class TechniqueSlot {
        public double slot;
        public boolean enabled;
        @ModElementReference
        public Procedure procedure;
        public String name = "";
        public double cost = 0;
        public boolean passive = false;
        public boolean physical = false;

        public TechniqueSlot(double slot) {
            this.slot = slot;
        }
    }
}
