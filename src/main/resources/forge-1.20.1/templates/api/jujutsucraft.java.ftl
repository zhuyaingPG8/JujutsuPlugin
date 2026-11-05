<#-- @formatter:off -->
package ${package}.apis;

import ${package}.apis.impl.JujutsuCursedDataImpl;
import ${package}.apis.impl.JujutsuPlayerDataImpl;
import net.mcreator.jujutsucraft.network.JujutsucraftModVariables;
import net.minecraft.world.entity.Entity;

public final class JujutsuCraft {
    public static JujutsuPlayerData getJujutsuPlayerData() {
        return JujutsuPlayerDataImpl.INSTANCE;
    }

    public static JujutsuCursedData getJujutsuCursedData() {
        return JujutsuCursedDataImpl.INSTANCE;
    }

    public static JujutsucraftModVariables.PlayerVariables cursedVars(Entity entity){
        return entity.getCapability(JujutsucraftModVariables.PLAYER_VARIABLES_CAPABILITY, null).orElse(new JujutsucraftModVariables.PlayerVariables());
    }
}
<#-- @formatter:on -->