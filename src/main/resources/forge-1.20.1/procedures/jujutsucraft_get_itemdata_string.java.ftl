<#include "mcitems.ftl">
${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().getString(${generator.map(field$key, "jujutsucraft_itemdata")})
