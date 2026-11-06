<#-- @formatter:off -->
package ${package}.mixins;

import net.mcreator.jujutsucraft.init.JujutsucraftModMobEffects;
import net.mcreator.jujutsucraft.procedures.DomainExpansionCreateBarrierProcedure;
import net.minecraft.advancements.Advancement;
import net.minecraft.advancements.AdvancementProgress;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.level.LevelAccessor;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(value = DomainExpansionCreateBarrierProcedure.class, priority = Integer.MAX_VALUE)
public class ${JavaModName}DomainOpenBarrierMixin {
    @Unique
    private static final String OPEN_BARRIER_ADVANCEMENT = "jujutsucraft:mastery_open_barrier_type_domain";

    @Inject(method = "execute(Lnet/minecraft/world/level/LevelAccessor;DDDLnet/minecraft/world/entity/Entity;)V",
        at = @At(value = "INVOKE", target = "Lnet/mcreator/jujutsucraft/procedures/DomainExpansionBattleProcedure;execute(Lnet/minecraft/world/level/LevelAccessor;DDDLnet/minecraft/world/entity/Entity;)V",
        shift = At.Shift.BEFORE), remap = false)
    private static void onBeforeDomainBattle(LevelAccessor world, double x, double y, double z, Entity entity, CallbackInfo ci) {
        if (entity == null) return;

        CompoundTag tag = entity.getPersistentData();
        if (!isOpenDomainTechnique(tag)) return;
        if (tag.getDouble("cnt1") != 1.0) return;
        if (entity.isShiftKeyDown()) return;
        if (!canUseOpenDomain(entity)) return;

        tag.putDouble("cnt2", 1.0);
    }

    @Unique
    private static boolean isOpenDomainTechnique(CompoundTag tag) {
        double domainNum = tag.getDouble("select") > 0.0 ? tag.getDouble("select") : tag.getDouble("skill_domain");
        return switch ((int) domainNum) {
<#list cursed_techniques?sort_by("sorcererId") as technique>
<#if technique.domainEnabled && technique.domainOpen>
            case ${technique.sorcererId} -> true;
</#if>
</#list>
            default -> false;
        };
    }

    @Unique
    private static boolean canUseOpenDomain(Entity entity) {
        if (entity instanceof ServerPlayer serverPlayer && serverPlayer.server != null) {
            Advancement advancement = serverPlayer.server.getAdvancements()
                    .getAdvancement(new ResourceLocation(OPEN_BARRIER_ADVANCEMENT));
            if (advancement != null) {
                AdvancementProgress progress = serverPlayer.getAdvancements().getOrStartProgress(advancement);
                if (progress.isDone()) return true;
            }
        }

        if (entity instanceof LivingEntity living && living.hasEffect(JujutsucraftModMobEffects.SUKUNA_EFFECT.get())) {
            return true;
        }

        return !(entity instanceof Player);
    }
}
<#-- @formatter:on -->