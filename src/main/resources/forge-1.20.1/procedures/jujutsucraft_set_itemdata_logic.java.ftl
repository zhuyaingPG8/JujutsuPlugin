<#include "mcitems.ftl">
${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().putBoolean(${generator.map(field$key, "jujutsucraft_itemdata")}, ${input$value});
