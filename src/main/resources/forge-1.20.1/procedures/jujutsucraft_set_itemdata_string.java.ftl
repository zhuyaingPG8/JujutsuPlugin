<#include "mcitems.ftl">
${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().putString(${generator.map(field$key, "jujutsucraft_itemdata")}, ${input$value});
