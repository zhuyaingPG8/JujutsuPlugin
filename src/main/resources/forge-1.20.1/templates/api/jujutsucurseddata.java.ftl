<#-- @formatter:off -->
package ${package}.apis;

import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.LevelAccessor;

public interface JujutsuCursedData {
    boolean switchDefault(Entity entity, double num);

    boolean setInfo(Entity entity, double selected, String name, double cost, boolean passive, boolean physical);

    boolean canDomainExpansion(Entity entity);

    void chantingIncantations(LevelAccessor world, double x, double y, double z, Entity entity, double num, String text, double energy);
}
<#-- @formatter:on -->