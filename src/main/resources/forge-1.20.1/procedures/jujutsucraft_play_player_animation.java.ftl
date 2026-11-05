
if (${input$entity} instanceof Player _player) {
	if (world.isClientSide()) {
		SetupAnimationsProcedure.setAnimationClientside(_player, "${generator.map(field$animation, "jujutsucraft_player_animations")}", true);
	} else {
		if (_player instanceof ServerPlayer _animPl) {
			JujutsucraftMod.PACKET_HANDLER.send(PacketDistributor.PLAYER.with(() -> _animPl), new SetupAnimationsProcedure.JujutsucraftModAnimationMessage("${generator.map(field$animation, "jujutsucraft_player_animations")}", _player.getId(), true));
		}
		JujutsucraftMod.PACKET_HANDLER.send(PacketDistributor.TRACKING_ENTITY.with(() -> _player), new SetupAnimationsProcedure.JujutsucraftModAnimationMessage("${generator.map(field$animation, "jujutsucraft_player_animations")}", _player.getId(), true));
	}
}
