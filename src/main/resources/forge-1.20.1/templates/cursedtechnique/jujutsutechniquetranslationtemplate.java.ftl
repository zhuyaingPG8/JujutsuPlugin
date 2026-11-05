<#-- @formatter:off -->
package ${package}.translation;

import ${package}.apis.JujutsuCraft;
import net.mcreator.jujutsucraft.init.JujutsucraftModMobEffects;
import net.minecraft.network.chat.Component;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;

public class ${name}SorcererTechniqueTranslation {
    public static boolean execute(Entity entity, double selected) {
        boolean found;
        switch ((int) selected) {
<#list data.slots as slot>
    <#if slot.enabled && slot.procedure??>
        <#if slot.slot != 20>
            case ${slot.slot}:
                found = JujutsuCraft.getJujutsuCursedData().setInfo(entity, selected, Component.translatable("technique.${modid}.skill_${slot?index}").getString(), ${slot.cost}, ${slot.passive?c}, ${slot.physical?c});
                break;
        <#else>
            case 20:
                if (entity instanceof Player _player && !_player.hasEffect(JujutsucraftModMobEffects.DOMAIN_EXPANSION.get())
                    && JujutsuCraft.getJujutsuCursedData().canDomainExpansion(_player)) {
                    found = JujutsuCraft.getJujutsuCursedData().setInfo(entity, selected, Component.translatable("technique.${modid}.skill_${slot?index}").getString(), ${slot.cost}, ${slot.passive?c}, ${slot.physical?c});
                    break;
                }
        </#if>
    </#if>
</#list>
            default:
                found = JujutsuCraft.getJujutsuCursedData().switchDefault(entity, selected);
        }
        return found;
    }
}
<#-- @formatter:on -->