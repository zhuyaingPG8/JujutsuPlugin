<#-- @formatter:off -->
package ${package}.mixins;

import ${package}.apis.JujutsuCraft;
import net.mcreator.jujutsucraft.network.JujutsucraftModVariables;
import net.mcreator.jujutsucraft.procedures.KeyChangeTechniqueOnKeyPressedProcedure;
import net.mcreator.jujutsucraft.procedures.KeyStartTechniqueOnKeyPressedProcedure;
import net.mcreator.jujutsucraft.procedures.KeyUseMainSkillOnKeyPressedProcedure;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.level.LevelAccessor;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(value = KeyUseMainSkillOnKeyPressedProcedure.class, priority = Integer.MIN_VALUE)
public class ${JavaModName}KeyUseMainSkillMixin {
    @Inject(method = "execute(Lnet/minecraft/world/level/LevelAccessor;DDDLnet/minecraft/world/entity/Entity;)V",
            at = @At("HEAD"), cancellable = true, remap = false)
    private static void onExecute(LevelAccessor world, double x, double y, double z, Entity entity, CallbackInfo ci) {
        if (!(entity instanceof Player _player)) return;
        double sorcerer = JujutsuCraft.getJujutsuPlayerData().getSorcererNumber(_player);
        if (!owned(sorcerer)) return;
        ci.cancel();
        if (_player.level().isClientSide()) return;
        double select = selected(sorcerer);
        double old_select = JujutsuCraft.cursedVars(_player).PlayerSelectCurseTechnique;
        _player.getCapability(JujutsucraftModVariables.PLAYER_VARIABLES_CAPABILITY, null).ifPresent((capability) -> {
            capability.use_mainSkill = true;
            capability.PlayerSelectCurseTechnique = select;
            capability.noChangeTechnique = true;
            capability.syncPlayerVariables(_player);
        });
        KeyChangeTechniqueOnKeyPressedProcedure.execute(world, x, y, z, _player);
        if (JujutsuCraft.cursedVars(_player).PlayerSelectCurseTechnique == select) {
            KeyStartTechniqueOnKeyPressedProcedure.execute(world, x, y, z, _player);
        }
        _player.getCapability(JujutsucraftModVariables.PLAYER_VARIABLES_CAPABILITY, null).ifPresent((capability) -> {
            capability.use_mainSkill = false;
            capability.PlayerSelectCurseTechnique = old_select;
            capability.noChangeTechnique = true;
            capability.syncPlayerVariables(_player);
        });
        KeyChangeTechniqueOnKeyPressedProcedure.execute(world, x, y, z, _player);
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

    private static double selected(double sorcerer) {
        double selected = 0;
        switch ((int) sorcerer) {
<#list cursed_techniques?sort_by("sorcererId") as technique>
            case ${technique.sorcererId} -> selected = ${technique.skillCase};
</#list>
        }
        return selected;
    }
}
<#-- @formatter:on -->