<#-- @formatter:off -->
package ${package}.apis.impl;

import ${package}.apis.JujutsuCraft;
import ${package}.apis.JujutsuPlayerData;
import net.mcreator.jujutsucraft.network.JujutsucraftModVariables;
import net.mcreator.jujutsucraft.procedures.ResetCounterProcedure;
import net.minecraft.world.entity.Entity;

public final class JujutsuPlayerDataImpl implements JujutsuPlayerData {
    public static final JujutsuPlayerData INSTANCE = new JujutsuPlayerDataImpl();

    public void setSorcerer(Entity entity, double num) {
        entity.getCapability(JujutsucraftModVariables.PLAYER_VARIABLES_CAPABILITY, null).ifPresent((capability) -> {
            capability.PlayerCurseTechnique = num;
            capability.syncPlayerVariables(entity);
        });
    }

    public double getSorcererNumber(Entity entity) {
        return JujutsuCraft.cursedVars(entity).SecondTechnique ? JujutsuCraft.cursedVars(entity).PlayerCurseTechnique2 : JujutsuCraft.cursedVars(entity).PlayerCurseTechnique;
    }

    public boolean getSorcererBoolean(Entity entity, double num) {
        return getSorcererNumber(entity) == num;
    }

    public double getSkillNumber(Entity entity) {
        double skill = entity.getPersistentData().getDouble("skill");
        return Math.round(skill - (getSorcererNumber(entity) * 100));
    }

    public double getSkillNumber(Entity entity, double num) {
        double skill = entity.getPersistentData().getDouble("skill");
        return Math.round(skill - (num * 100));
    }

    public void setSkillNumber(Entity entity, double num, double num1) {
        entity.getPersistentData().putDouble("skill", (num * 100) + num1);
        ResetCounterProcedure.execute(entity);
    }

    public boolean getSkillBoolean(Entity entity, double num) {
        return getSkillNumber(entity) == num;
    }

    public boolean getSkillBoolean(Entity entity, double num, double num1) {
        return getSkillNumber(entity, num) == num1;
    }
}
<#-- @formatter:on -->