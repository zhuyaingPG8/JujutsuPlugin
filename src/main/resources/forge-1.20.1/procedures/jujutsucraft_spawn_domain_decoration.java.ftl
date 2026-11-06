<#include "mcelements.ftl">
<#assign entity = generator.map(field$entity, "entities", 1)!"null">
<#if entity != "null">
if (world instanceof ServerLevel _domainLevel) {
	Entity _domainDecoration = ${entity}.create(_domainLevel, null, null, ${toBlockPos(input$x, input$y, input$z)}, MobSpawnType.MOB_SUMMONED, false, false);
	if (_domainDecoration != null) {
		Entity _domainOwner = ${input$owner};
		_domainDecoration.setYRot(world.getRandom().nextFloat() * 360.0F);
		if (!_domainDecoration.level().isClientSide() && _domainDecoration.getServer() != null) {
			_domainDecoration.getServer().getCommands().performPrefixedCommand(new CommandSourceStack(CommandSource.NULL, _domainDecoration.position(), _domainDecoration.getRotationVector(), _domainDecoration.level() instanceof ServerLevel ? (ServerLevel) _domainDecoration.level() : null, 4, _domainDecoration.getName().getString(), _domainDecoration.getDisplayName(), _domainDecoration.level().getServer(), _domainDecoration), "data merge entity @s {<#if field$noai == "TRUE">NoAI:1b,</#if>Invulnerable:1b}");
		}
<#if field$rotation == "owner">
		_domainDecoration.setYRot(_domainOwner.getYRot());
<#elseif field$rotation == "owner_offset">
		_domainDecoration.setYRot(_domainOwner.getYRot() + (float) ${input$angle});
<#elseif field$rotation == "axis">
		_domainDecoration.setYRot(_domainOwner.getDirection() != Direction.NORTH && _domainOwner.getDirection() != Direction.SOUTH ? 90.0F : (float) ${input$angle});
<#elseif field$rotation == "absolute">
		_domainDecoration.setYRot((float) ${input$angle});
<#elseif field$rotation == "random">
		_domainDecoration.setYRot(world.getRandom().nextFloat() * 360.0F);
</#if>
		_domainDecoration.setXRot(0.0F);
		_domainDecoration.setYBodyRot(_domainDecoration.getYRot());
		_domainDecoration.setYHeadRot(_domainDecoration.getYRot());
		_domainDecoration.yRotO = _domainDecoration.getYRot();
		_domainDecoration.xRotO = _domainDecoration.getXRot();
		if (_domainDecoration instanceof LivingEntity _domainLiving) {
			_domainLiving.yBodyRotO = _domainLiving.getYRot();
			_domainLiving.yHeadRotO = _domainLiving.getYRot();
		}
		if (_domainOwner != null) {
			if (_domainOwner.getPersistentData().getDouble("NameRanged") == 0.0) {
				_domainOwner.getPersistentData().putDouble("NameRanged", Math.random());
			}
			_domainDecoration.getPersistentData().putDouble("NameRanged_ranged", _domainOwner.getPersistentData().getDouble("NameRanged"));
			_domainDecoration.getPersistentData().putString("OWNER_UUID", _domainOwner.getStringUUID());
		}
		_domainLevel.addFreshEntity(_domainDecoration);
	}
}
</#if>