<#-- @formatter:off -->
<#include "/procedures.java.ftl">
package ${package}.mixins;

import net.mcreator.jujutsucraft.procedures.DomainActiveProcedure;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.LevelAccessor;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
<#list cursed_techniques?sort_by("sorcererId") as technique>
<#if technique.domainEnabled && technique.domainActiveEnabled && hasProcedure(technique.domainActive)>
import ${package}.procedures.${technique.domainActive.getName()}Procedure;
</#if>
</#list>

@Mixin(value = DomainActiveProcedure.class, priority = Integer.MAX_VALUE)
public class ${JavaModName}DomainActiveMixin {
    @Inject(method = "execute(Lnet/minecraft/world/level/LevelAccessor;DDDLnet/minecraft/world/entity/Entity;)V",
        at = @At("HEAD"), cancellable = true, remap = false)
    private static void onExecute(LevelAccessor world, double x, double y, double z, Entity entity, CallbackInfo ci) {
        if (entity == null) return;

        CompoundTag tag = entity.getPersistentData();
<#list cursed_techniques?sort_by("sorcererId") as technique>
<#if technique.domainEnabled && technique.domainActiveEnabled && hasProcedure(technique.domainActive)>
        if ((int) tag.getDouble("skill_domain") == ${technique.sorcererId}) {
            <@procedureToCode name=technique.domainActive.getName()
                    dependencies=technique.domainActive.getDependencies(generator.getWorkspace())
                    customVals={"world": "world", "x": "x", "y": "y", "z": "z", "entity": "entity"}/>
            ci.cancel();
            return;
        }
</#if>
</#list>
    }
}
<#-- @formatter:on -->