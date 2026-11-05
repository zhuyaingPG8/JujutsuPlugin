<#-- @formatter:off -->
package ${package}.mixins;

import net.mcreator.jujutsucraft.procedures.CursedTechniqueOnPotionActiveTickProcedure;
<#list cursed_techniques?sort_by("sorcererId") as technique>
import ${package}.technique.${technique.getModElement().getName()}SorcererTechnique;
</#list>
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.LevelAccessor;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(value = CursedTechniqueOnPotionActiveTickProcedure.class, priority = Integer.MAX_VALUE)
public class ${JavaModName}CursedTechniqueActiveMixin {
    @Inject(method = "execute(Lnet/minecraft/world/level/LevelAccessor;DDDLnet/minecraft/world/entity/Entity;)V",
            at = @At("HEAD"), cancellable = true, remap = false)
    private static void onExecute(LevelAccessor world, double x, double y, double z, Entity entity, CallbackInfo ci) {
        if (entity != null) {
            boolean found = false;
            double skill = entity.getPersistentData().getDouble("skill");

<#list cursed_techniques?sort_by("sorcererId") as technique>
            if (skill >= ${technique.sorcererId * 100} && skill < ${(technique.sorcererId + 1) * 100}) {
                found = ${technique.getModElement().getName()}SorcererTechnique.execute(world, x, y, z, entity);
            }
</#list>

            if (found) {
                ci.cancel();
            }
        }
    }
}
<#-- @formatter:on -->