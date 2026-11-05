<#-- @formatter:off -->
<#include "/procedures.java.ftl">
<#function slotImports element>
    <#assign sb = "">
    <#list element.slots as slot>
        <#if slot.enabled && slot.procedure??>
            <#assign sb = sb + "import " + "${package}.procedures." + slot.procedure.getName() + "Procedure;">
        </#if>
    </#list>
    <#return sb>
</#function>
package ${package}.technique;

import ${package}.apis.JujutsuCraft;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.LevelAccessor;
${slotImports(data)}

public class ${name}SorcererTechnique {
    public static boolean execute(LevelAccessor world, double x, double y, double z, Entity entity) {
        boolean found = false;
        double skill = JujutsuCraft.getJujutsuPlayerData().getSkillNumber(entity);
        switch ((int) skill) {
<#list data.slots as slot>
    <#if slot.enabled && slot.procedure??>
            case ${slot.slot}:
                <@procedureToCode name=slot.procedure.getName() dependencies=slot.procedure.getDependencies(generator.getWorkspace())/>
                found = true;
        <#if slot.slot != 20>
                break;
        </#if>
    </#if>
</#list>
        }
        return found;
    }
}
<#-- @formatter:on -->