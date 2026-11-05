<#-- @formatter:off -->
package ${package}.apis;

import net.minecraft.world.entity.Entity;

public interface JujutsuPlayerData {
    void setSorcerer(Entity entity, double num);

    double getSorcererNumber(Entity entity);

    boolean getSorcererBoolean(Entity entity, double num);

    double getSkillNumber(Entity entity);

    double getSkillNumber(Entity entity, double num);

    void setSkillNumber(Entity entity, double num, double num1);

    boolean getSkillBoolean(Entity entity, double num);

    boolean getSkillBoolean(Entity entity, double num, double num1);
}
<#-- @formatter:on -->