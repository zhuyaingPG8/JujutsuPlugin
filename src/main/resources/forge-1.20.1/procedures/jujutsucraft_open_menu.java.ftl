<#include "mcelements.ftl">
if(${input$entity} instanceof ServerPlayer _ent) {
	BlockPos _bpos = ${toBlockPos(input$x,input$y,input$z)};
	NetworkHooks.openScreen((ServerPlayer) _ent, new MenuProvider() {
		@Override public Component getDisplayName() {
			return Component.literal("${generator.map(field$menu, "jujutsucraft_menus")}");
		}
		@Override public AbstractContainerMenu createMenu(int id, Inventory inventory, Player player) {
			return new ${generator.map(field$menu, "jujutsucraft_menus")}Menu(id, inventory, new FriendlyByteBuf(Unpooled.buffer()).writeBlockPos(_bpos));
		}
	}, _bpos);
}
