<#-- @formatter:off -->
package ${package}.apis.impl;

import ${package}.apis.JujutsuCraft;
import ${package}.apis.JujutsuCursedData;
import net.mcreator.jujutsucraft.init.JujutsucraftModMobEffects;
import net.mcreator.jujutsucraft.procedures.ChangeCurseEnergyProcedure;
import net.mcreator.jujutsucraft.procedures.TechniqueDecideProcedure;
import net.minecraft.advancements.Advancement;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.effect.MobEffect;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelAccessor;

public final class JujutsuCursedDataImpl implements JujutsuCursedData {
    public static final JujutsuCursedData INSTANCE = new JujutsuCursedDataImpl();

    public boolean switchDefault(Entity entity, double num) {
        boolean found = false;
        MobEffect domain_expansion = JujutsucraftModMobEffects.DOMAIN_EXPANSION.get();
        if (entity instanceof Player _player && !_player.level().isClientSide()) {
            if (num >= 0 && num <= 2){
                found = setInfo(_player, num, Component.translatable("jujutsu.technique.attack" + Math.round(num + 1)).getString(), 0, false, true);
            }else if (_player.hasEffect(domain_expansion) && num == 21){
                found = setInfo(_player, num, Component.translatable("jujutsu.technique.cancel_domain").getString(), 0, true, true);
            }
        }
        return found;
    }

    public boolean setInfo(Entity entity, double selected, String name, double cost, boolean passive, boolean physical) {
        if (entity.level().isClientSide()) return false;
        double ct = JujutsuCraft.getJujutsuPlayerData().getSorcererNumber(entity);
        TechniqueDecideProcedure.execute(entity, passive, physical, cost, ct, selected, name);
        return true;
    }

    public boolean canDomainExpansion(Entity entity) {
        if (ignoreRequirements(entity)) {
            return true;
        } else if (entity instanceof ServerPlayer serverPlayer) {
            Advancement _adv = serverPlayer.server.getAdvancements().getAdvancement(new ResourceLocation("jujutsucraft:mastery_domain_expansion"));
            return _adv != null && serverPlayer.getAdvancements().getOrStartProgress(_adv).isDone();
        } else {
            return false;
        }
    }

    public void chantingIncantations(LevelAccessor world, double x, double y, double z, Entity entity, double num, String text, double energy) {
        double cnt6 = entity.getPersistentData().getDouble("cnt6");
        double cnt5 = entity.getPersistentData().getDouble("cnt5");
        double num1 = num + 2;
        if (cnt6 < num){
            entity.getPersistentData().putDouble("cnt5", cnt5 + 1);
            if (cnt5 > 20){
                entity.getPersistentData().putDouble("cnt5", 0);
                entity.getPersistentData().putDouble("cnt6", cnt6 + 1);
                if (entity instanceof Player _player && !_player.level().isClientSide()) {
                    _player.displayClientMessage(Component.literal("§l\"" + Component.translatable(text + Math.round(entity.getPersistentData().getDouble("cnt6"))).getString() + "\""), false);
                    ChangeCurseEnergyProcedure.execute(_player, -energy);
                }
            }
        } else if (cnt6 < num1) {
            entity.getPersistentData().putDouble("cnt6", num1);
            if (world instanceof Level _level) {
                if (!_level.isClientSide()) {
                    _level.explode(null, x, y, z, 0, Level.ExplosionInteraction.NONE);
                }
            }
        }
    }

    private static boolean ignoreRequirements(Entity entity) {
        if (entity instanceof ServerPlayer serverPlayer) {
            return serverPlayer.isCreative();
        } else {
            return false;
        }
    }
}
<#-- @formatter:on -->