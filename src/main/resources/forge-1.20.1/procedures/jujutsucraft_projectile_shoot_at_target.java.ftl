<#assign _proj = generator.map(field$projectile, "jujutsucraft_projectiles", 0)!"null">
<#if _proj != "null">
{
	Entity _shootFrom = ${input$entity};
	Entity _shootTarget = ${input$target};
	if (_shootFrom instanceof LivingEntity _shooter && _shootTarget instanceof LivingEntity _aim
			&& !_shooter.level().isClientSide()) {
		${_proj}.shoot(_shooter, _aim);
	}
}
</#if>
