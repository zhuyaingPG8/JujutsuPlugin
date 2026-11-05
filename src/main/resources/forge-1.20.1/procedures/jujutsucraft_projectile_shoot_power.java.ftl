<#assign _proj = generator.map(field$projectile, "jujutsucraft_projectiles", 0)!"null">
<#if _proj != "null">
{
	Entity _shootFrom = ${input$entity};
	if (_shootFrom instanceof LivingEntity _shooter && !_shooter.level().isClientSide()) {
		${_proj}.shoot(_shooter.level(), _shooter, _shooter.level().getRandom(), ${opt.toFloat(input$power)});
	}
}
</#if>
