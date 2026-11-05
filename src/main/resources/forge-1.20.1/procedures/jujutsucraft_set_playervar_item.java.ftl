<#include "mcitems.ftl">
{
	JujutsucraftModVariables.PlayerVariables _vars${cbi} = ${input$entity}.getCapability(JujutsucraftModVariables.PLAYER_VARIABLES_CAPABILITY, null).orElse(new JujutsucraftModVariables.PlayerVariables());
	_vars${cbi}.${generator.map(field$variable, "jujutsucraft_playervars")} = ${mappedMCItemToItemStackCode(input$value)};
	_vars${cbi}.syncPlayerVariables(${input$entity});
}
