<#-- @formatter:off -->
package ${package}.mixins;

import ${package}.apis.JujutsuCraft;
import net.mcreator.jujutsucraft.procedures.KeyChangeTechniqueOnKeyPressedProcedure;
<#list cursed_techniques?sort_by("sorcererId") as technique>
import ${package}.translation.${technique.getModElement().getName()}SorcererTechniqueTranslation;
</#list>
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.level.LevelAccessor;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(value = KeyChangeTechniqueOnKeyPressedProcedure.class, priority = Integer.MAX_VALUE)
public class ${JavaModName}KeyChangeTechniqueMixin {
    @Inject(method = "execute(Lnet/minecraft/world/level/LevelAccessor;DDDLnet/minecraft/world/entity/Entity;)V",
            at = @At("HEAD"), cancellable = true, remap = false)
    private static void onExecute(LevelAccessor world, double x, double y, double z, Entity entity, CallbackInfo ci) {
        if (!(entity instanceof Player player)) return;
        double sorcerer = JujutsuCraft.getJujutsuPlayerData().getSorcererNumber(player);
        if (!owned(sorcerer)) return;
        ci.cancel();
        if (player.level().isClientSide()) return;

        double selected = JujutsuCraft.cursedVars(player).PlayerSelectCurseTechnique;
        if (!JujutsuCraft.cursedVars(player).noChangeTechnique) {
            selected = step(selected, player.isShiftKeyDown() ? -1 : 1);
        }

        for (int i = 0; i < 35; ++i) {
            if (translate(sorcerer, player, selected)) {
                return;
            }
            selected = step(selected, player.isShiftKeyDown() ? -1 : 1);
        }
    }

    private static boolean owned(double sorcerer) {
        boolean found = false;
        switch ((int) sorcerer) {
<#list cursed_techniques?sort_by("sorcererId") as technique>
            case ${technique.sorcererId} -> found = true;
</#list>
        }
        return found;
    }

    private static boolean translate(double sorcerer, Player player, double selected) {
        boolean found = false;
        switch ((int) sorcerer) {
<#list cursed_techniques?sort_by("sorcererId") as technique>
            case ${technique.sorcererId} -> found = ${technique.getModElement().getName()}SorcererTechniqueTranslation.execute(player, selected);
</#list>
        }
        return found;
    }

    private static double step(double selected, int delta) {
        selected += delta;
        if (selected < 0) {
            return 21;
        } else if (selected > 21) {
            return 0;
        }
        return selected;
    }
}
<#-- @formatter:on -->