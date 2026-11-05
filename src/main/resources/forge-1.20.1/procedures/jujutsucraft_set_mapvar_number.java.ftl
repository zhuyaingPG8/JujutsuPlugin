if (!world.isClientSide()) {
	JujutsucraftModVariables.MapVariables.get(world).${generator.map(field$variable, "jujutsucraft_mapvars")} = ${input$value};
	JujutsucraftModVariables.MapVariables.get(world).syncData(world);
}
