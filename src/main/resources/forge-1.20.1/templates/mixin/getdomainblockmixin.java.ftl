<#-- @formatter:off -->
package ${package}.mixins;

import net.mcreator.jujutsucraft.procedures.GetDomainBlockProcedure;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.world.entity.Entity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(value = GetDomainBlockProcedure.class, priority = Integer.MAX_VALUE)
public class ${JavaModName}GetDomainBlockMixin {
    @Inject(method = "execute(Lnet/minecraft/world/entity/Entity;)V", at = @At("RETURN"), remap = false)
    private static void onExecute(Entity entity, CallbackInfo ci){
        if (entity == null) return;
        CompoundTag domainTag = entity.getPersistentData();
        String domain_outside = domainTag.getString("domain_outside");
        if (domain_outside.isEmpty() || "minecraft:air".equals(domain_outside)) return;
        double domain_num = domainTag.getDouble("select") > 0 ? domainTag.getDouble("select") : domainTag.getDouble("skill_domain");

        String[] domain_palette = switch ((int) domain_num) {
<#list cursed_techniques?sort_by("sorcererId") as technique>
<#if technique.domainEnabled && technique.domainInside?? && technique.domainFloor?? && technique.domainInside.getUnmappedValue()?has_content && technique.domainFloor.getUnmappedValue()?has_content>
            case ${technique.sorcererId} -> new String[]{"${technique.domainInside.getMappedValue(1)}",  "${technique.domainFloor.getMappedValue(1)}"};
</#if>
</#list>
            default  -> null;
        };

        if (domain_palette == null) return;
        domainTag.putString("domain_inside",  domain_palette[0]);
        domainTag.putString("domain_floor",   domain_palette[1]);
    }
}
<#-- @formatter:on -->