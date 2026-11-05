<#include "mcitems.ftl">
${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().getBoolean(${generator.map(field$key, "jujutsucraft_itemdata")})
